#pragma once

#include "./Macro.hpp"
#include "./Math.hpp"
#include "./NormalForm.hpp"
#include "./Symbolics.hpp"

// prints in current permutation order.
// TODO: decide if we want to make AffineLoopNest a `SymbolicPolyhedra`
// in which case, we have to remove `currentToOriginalPerm`,
// which menas either change printing, or move prints `<<` into
// the derived classes.
template <typename T>
static std::ostream &
printConstraints(std::ostream &os, PtrMatrix<int64_t> A, llvm::ArrayRef<T> b,
                 bool inequality = true, size_t numAuxVar = 0) {
    const unsigned numConstraints = A.numCol();
    const unsigned numVar = A.numRow();
    for (size_t c = 0; c < numConstraints; ++c) {
        bool hasPrinted = false;
        for (size_t v = 0; v < numVar; ++v) {
            if (int64_t Acv = A(c, v)) {
                if (hasPrinted) {
                    if (Acv > 0) {
                        os << " + ";
                    } else {
                        os << " - ";
                        Acv *= -1;
                    }
                }
                if (Acv != 1) {
                    if (Acv == -1) {
                        os << "-";
                    } else {
                        os << Acv;
                    }
                }
                if (v >= numAuxVar) {
                    os << "v_" << v - numAuxVar;
                } else {
                    os << "d_" << v;
                }
                hasPrinted = true;
            }
        }
        if (inequality) {
            os << " <= ";
        } else {
            os << " == ";
        }
        os << b[c] << std::endl;
    }
    return os;
}
template <typename T>
static std::ostream &printConstraints(std::ostream &os, PtrMatrix<int64_t> A,
                                      llvm::SmallVectorImpl<T> &b,
                                      bool inequality = true,
                                      size_t numAuxVar = 0) {
    return printConstraints(os, A, llvm::ArrayRef<int64_t>(b), inequality,
                            numAuxVar);
}

// does not preserve the order of columns, instead it swaps the `i`th column
// to the last, and truncates.
MULTIVERSION static void eraseConstraintImpl(PtrMatrix<int64_t> A,
                                             llvm::MutableArrayRef<int64_t> b,
                                             size_t i) {
    const auto [M, N] = A.size();
    const size_t lastRow = M - 1;
    if (lastRow != i) {
        VECTORIZE
        for (size_t n = 0; n < N; ++n) {
            A(i, n) = A(lastRow, n);
        }
        b[i] = b[lastRow];
    }
}
MULTIVERSION static void eraseConstraintImpl(PtrMatrix<int64_t> A,
                                             llvm::MutableArrayRef<MPoly> b,
                                             size_t i) {
    const auto [M, N] = A.size();
    const size_t lastRow = M - 1;
    if (lastRow != i) {
        VECTORIZE
        for (size_t n = 0; n < N; ++n) {
            A(i, n) = A(lastRow, n);
        }
        b[i] = b[lastRow];
    }
}
template <typename T>
static void eraseConstraint(IntMatrix &A, llvm::SmallVectorImpl<T> &b,
                            size_t i) {
    eraseConstraintImpl(A, llvm::MutableArrayRef<T>(b), i);
    const size_t lastRow = A.numRow() - 1;
    A.truncateRows(lastRow);
    b.truncate(lastRow);
}

template <typename T>
static void eraseConstraint(IntMatrix &A, llvm::SmallVectorImpl<T> &b,
                            size_t _i, size_t _j) {
    assert(_i != _j);
    size_t i = std::min(_i, _j);
    size_t j = std::max(_i, _j);
    const auto [M, N] = A.size();
    const size_t lastRow = M - 1;
    const size_t penuRow = lastRow - 1;
    if (j == penuRow) {
        // then we only need to copy one column (i to lastCol)
        eraseConstraint(A, b, i);
    } else if (i != penuRow) {
        // if i == penuCol, then j == lastCol
        // and we thus don't need to copy
        if (lastRow != i) {
            for (size_t n = 0; n < N; ++n) {
                A(i, n) = A(penuRow, n);
                A(j, n) = A(lastRow, n);
            }
            b[i] = b[penuRow];
            b[j] = b[lastRow];
        }
    }
    A.truncateRows(penuRow);
    b.truncate(penuRow);
}

MULTIVERSION static size_t
substituteEqualityImpl(IntMatrix &E, llvm::SmallVectorImpl<MPoly> &q,
                       const size_t i) {
    const auto [numConstraints, numVar] = E.size();
    size_t minNonZero = numVar + 1;
    size_t rowMinNonZero = numConstraints;
    for (size_t j = 0; j < numConstraints; ++j) {
        if (E(j, i)) {
            size_t nonZero = 0;
            VECTORIZE
            for (size_t v = 0; v < numVar; ++v) {
                nonZero += (E(j, v) != 0);
            }
            if (nonZero < minNonZero) {
                minNonZero = nonZero;
                rowMinNonZero = j;
            }
        }
    }
    if (rowMinNonZero == numConstraints) {
        return rowMinNonZero;
    }
    auto Es = E.getRow(rowMinNonZero);
    int64_t Eis = Es[i];
    // we now subsitute the equality expression with the minimum number
    // of terms.
    if (std::abs(Eis) == 1) {
        for (size_t j = 0; j < numConstraints; ++j) {
            if (j == rowMinNonZero)
                continue;
            if (int64_t Eij = E(j, i)) {
                VECTORIZE
                for (size_t v = 0; v < numVar; ++v) {
                    E(j, v) = Eis * E(j, v) - Eij * Es[v];
                }
                Polynomial::fnmadd(q[j] *= Eis, q[rowMinNonZero], Eij);
            }
        }
    } else {
        for (size_t j = 0; j < numConstraints; ++j) {
            if (j == rowMinNonZero)
                continue;
            if (int64_t Eij = E(j, i)) {
                int64_t g = gcd(Eij, Eis);
                int64_t Ag = Eij / g;
                int64_t Eg = Eis / g;
                VECTORIZE
                for (size_t v = 0; v < numVar; ++v) {
                    E(j, v) = Eg * E(j, v) - Ag * Es[v];
                }
                Polynomial::fnmadd(q[j] *= Eg, q[rowMinNonZero], Ag);
            }
        }
    }
    return rowMinNonZero;
}
MULTIVERSION static size_t
substituteEqualityImpl(IntMatrix &E, llvm::SmallVectorImpl<int64_t> &q,
                       const size_t i) {
    const auto [numConstraints, numVar] = E.size();
    size_t minNonZero = numVar + 1;
    size_t rowMinNonZero = numConstraints;
    for (size_t j = 0; j < numConstraints; ++j) {
        if (E(j, i)) {
            size_t nonZero = 0;
            VECTORIZE
            for (size_t v = 0; v < numVar; ++v) {
                nonZero += (E(j, v) != 0);
            }
            if (nonZero < minNonZero) {
                minNonZero = nonZero;
                rowMinNonZero = j;
            }
        }
    }
    if (rowMinNonZero == numConstraints) {
        return rowMinNonZero;
    }
    auto Es = E.getRow(rowMinNonZero);
    int64_t Eis = Es[i];
    // we now subsitute the equality expression with the minimum number
    // of terms.
    if (std::abs(Eis) == 1) {
        for (size_t j = 0; j < numConstraints; ++j) {
            if (j == rowMinNonZero)
                continue;
            if (int64_t Eij = E(j, i)) {
                VECTORIZE
                for (size_t v = 0; v < numVar; ++v) {
                    E(j, v) = Eis * E(j, v) - Eij * Es[v];
                }
                Polynomial::fnmadd(q[j] *= Eis, q[rowMinNonZero], Eij);
            }
        }
    } else {
        for (size_t j = 0; j < numConstraints; ++j) {
            if (j == rowMinNonZero)
                continue;
            if (int64_t Eij = E(j, i)) {
                int64_t g = std::gcd(Eij, Eis);
                int64_t Ag = Eij / g;
                int64_t Eg = Eis / g;
                VECTORIZE
                for (size_t v = 0; v < numVar; ++v) {
                    E(j, v) = Eg * E(j, v) - Ag * Es[v];
                }
                Polynomial::fnmadd(q[j] *= Eg, q[rowMinNonZero], Ag);
            }
        }
    }
    return rowMinNonZero;
}
template <typename T>
static bool substituteEquality(IntMatrix &E, llvm::SmallVectorImpl<T> &q,
                               const size_t i) {
    size_t colMinNonZero = substituteEqualityImpl(E, q, i);
    if (colMinNonZero != E.numCol()) {
        eraseConstraint(E, q, colMinNonZero);
        return false;
    }
    return true;
}

template <typename T>
static size_t substituteEqualityImpl(IntMatrix &A, llvm::SmallVectorImpl<T> &b,
                                     IntMatrix &E, llvm::SmallVectorImpl<T> &q,
                                     const size_t i) {
    const auto [numConstraints, numVar] = E.size();
    size_t minNonZero = numVar + 1;
    size_t rowMinNonZero = numConstraints;
    for (size_t j = 0; j < numConstraints; ++j) {
        if (E(i, j)) {
            // if (std::abs(E(i,j)) == 1){
            size_t nonZero = 0;
            for (size_t v = 0; v < numVar; ++v) {
                nonZero += (E(j, v) != 0);
            }
            if (nonZero < minNonZero) {
                minNonZero = nonZero;
                rowMinNonZero = j;
            }
        }
    }
    if (rowMinNonZero == numConstraints) {
        return rowMinNonZero;
    }
    auto Es = E.getCol(rowMinNonZero);
    int64_t Eis = Es[i];
    int64_t s = 2 * (Eis > 0) - 1;
    // we now subsitute the equality expression with the minimum number
    // of terms.
    if (std::abs(Eis) == 1) {
        for (size_t j = 0; j < A.numCol(); ++j) {
            if (int64_t Aij = A(j, i)) {
                // `A` contains inequalities; flipping signs is illegal
                int64_t Ag = (s * Aij);
                int64_t Eg = (s * Eis);
                for (size_t v = 0; v < numVar; ++v) {
                    A(j, v) = Eg * A(j, v) - Ag * Es[v];
                }
                Polynomial::fnmadd(b[j] *= Eg, q[rowMinNonZero], Ag);
                // TODO: check if should drop
            }
        }
        for (size_t j = 0; j < numConstraints; ++j) {
            if (j == rowMinNonZero)
                continue;
            if (int64_t Eij = E(j, i)) {
                for (size_t v = 0; v < numVar; ++v) {
                    E(j, v) = Eis * E(j, v) - Eij * Es[v];
                }
                Polynomial::fnmadd(q[j] *= Eis, q[rowMinNonZero], Eij);
            }
        }
    } else {
        for (size_t j = 0; j < A.numCol(); ++j) {
            if (int64_t Aij = A(j, i)) {
                int64_t g = std::gcd(Aij, Eis);
                assert(g > 0);
                // `A` contains inequalities; flipping signs is illegal
                int64_t Ag = (s * Aij) / g;
                int64_t Eg = (s * Eis) / g;
                for (size_t v = 0; v < numVar; ++v) {
                    A(j, v) = Eg * A(j, v) - Ag * Es[v];
                }
                Polynomial::fnmadd(b[j] *= Eg, q[rowMinNonZero], Ag);
                // TODO: check if should drop
            }
        }
        for (size_t j = 0; j < numConstraints; ++j) {
            if (j == rowMinNonZero)
                continue;
            if (int64_t Eij = E(j, i)) {
                int64_t g = std::gcd(Eij, Eis);
                int64_t Ag = Eij / g;
                int64_t Eg = Eis / g;
                for (size_t v = 0; v < numVar; ++v) {
                    E(j, v) = Eg * E(j, v) - Ag * Es[v];
                }
                Polynomial::fnmadd(q[j] *= Eg, q[rowMinNonZero], Ag);
            }
        }
    }
    return rowMinNonZero;
}
template <typename T>
static bool substituteEquality(IntMatrix &A, llvm::SmallVectorImpl<T> &b,
                               IntMatrix &E, llvm::SmallVectorImpl<T> &q,
                               const size_t i) {

    size_t colMinNonZero = substituteEqualityImpl(A, b, E, q, i);
    if (colMinNonZero != E.numCol()) {
        eraseConstraint(E, q, colMinNonZero);
        return false;
    }
    return true;
}
// (A*x <= b) && (E*x == q)
template <typename T>
void removeExtraVariables(IntMatrix &A, llvm::SmallVectorImpl<T> &b,
                          IntMatrix &E, llvm::SmallVectorImpl<T> &q,
                          const size_t numNewVar) {
    // N variables
    // M inequality constraints
    // K equality constraints
    const auto [M, N] = A.size();
    const size_t K = E.numRow();
    assert(b.size() == M);
    assert(q.size() == K);
    // We add M augment variables (a_m), one per inequality constraint
    // a_n = b_n - (A*x)_n, so a_n >= 0
    // C's first N columns contain constraints from A, last K from E
    // so we have C*x = [b; q]
    // C = [ I A
    //       0 E ]
    IntMatrix C(M + K, M + N);
    llvm::SmallVector<T> d(M + K);
    for (size_t m = 0; m < M; ++m) {
        C(m, m) = 1;
        for (size_t n = 0; n < N; ++n) {
            C(m, M + n) = A(m, n);
        }
        d[m] = b[m];
    }
    for (size_t k = 0; k < K; ++k) {
        for (size_t n = 0; n < N; ++n) {
            C(M + k, M + n) = E(k, n);
        }
        d[M + k] = q[k];
    }
    for (size_t o = M + N; o > numNewVar + N;) {
        --o;
        substituteEquality(C, d, o);
        if (C.numCol() > 1) {
            NormalForm::simplifyEqualityConstraints(C, d);
        }
    }
    A.resizeForOverwrite(numNewVar, N);
    b.resize_for_overwrite(N);
    size_t nC = 0, nA = 0, i = 0;
    // TODO: document behavior and actually verify correctness...
    // what if we have a_3 - a_7 + .... = ....
    // if another constraint reveals `a_3 = 33`, then this isn't unbounded
    // and we are not allowed to just drop the constraint...
    // However, if we had that, the a_3 would zero-out, so normal form
    // eliminates this possiblity.
    // Or, what if 2*a_3 - 3*a_7 == 1?
    // Then, we have a line, and a_3 - a_7 could still be anything.
    while ((i < N) && (nC < C.numCol()) && (nA < N)) {
        if (C(nC, i++)) {
            // if we have multiple positives, that still represents a positive
            // constraint, as augments are >=. if we have + and -, then the
            // relationship becomes unknown and thus dropped.
            bool otherNegative = false;
            for (size_t j = i; j < N; ++j) {
                otherNegative |= (C(nC, j) < 0);
            }
            if (otherNegative) {
                ++nC;
                continue;
            }
            bool duplicate = false;
            for (size_t k = 0; k < nA; ++k) {
                bool allMatch = true;
                for (size_t m = 0; m < numNewVar; ++m) {
                    allMatch &= (A(k, m) == C(nC, N + m));
                }
                if (allMatch) {
                    duplicate = true;
                    break;
                }
            }
            if (duplicate) {
                ++nC;
                continue;
            }
            for (size_t m = 0; m < numNewVar; ++m) {
                A(nA, m) = C(nC, N + m);
            }
            b[nA] = d[nC];
            ++nA;
            ++nC;
        }
    }
    A.truncateRows(nA);
    b.truncate(nA);
    E.resizeForOverwrite(numNewVar, C.numCol() - nC);
    q.resize_for_overwrite(C.numCol() - nC);
    for (size_t i = 0; i < E.numCol(); ++i) {
        for (size_t m = 0; m < numNewVar; ++m) {
            E(i, m) = C(nC + i, N + m);
        }
        q[i] = d[nC + i];
    }
    // pruneBounds(A, b, E, q);
}
