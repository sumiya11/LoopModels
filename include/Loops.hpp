#pragma once

#include "./Math.hpp"
#include "./POSet.hpp"
#include "./Permutation.hpp"
#include "./Polyhedra.hpp"
#include "./Symbolics.hpp"
#include "Comparators.hpp"
#include "Constraints.hpp"
#include "EmptyArrays.hpp"
#include <cstddef>
#include <cstdint>
#include <llvm/ADT/ArrayRef.h>
#include <llvm/ADT/DenseMap.h>
#include <llvm/ADT/IntrusiveRefCntPtr.h>
#include <llvm/ADT/SmallVector.h>

// A' * i <= b
// l are the lower bounds
// u are the upper bounds
// extrema are the extremes, in orig order
struct AffineLoopNest : Polyhedra<EmptyMatrix<int64_t>, SymbolicComparator> {

    static Polyhedra<EmptyMatrix<int64_t>, SymbolicComparator>
    symbolicPolyhedra(const IntMatrix &A, llvm::ArrayRef<MPoly> b,
                      PartiallyOrderedSet poset) {
        assert(b.size() == A.numRow());
        IntMatrix B;
        llvm::SmallVector<Polynomial::Monomial> monomials;
        llvm::DenseMap<Polynomial::Monomial, unsigned> map;

        for (auto &p : b)
            for (auto &t : p)
                if (!t.isCompileTimeConstant())
                    if (map.insert(std::make_pair(t.exponent, map.size()))
                            .second)
                        monomials.push_back(t.exponent);
        const size_t numMonomials = monomials.size();
        B.resize(A.numRow(), A.numCol() + 1 + map.size());
        for (size_t r = 0; r < A.numRow(); ++r) {
            for (auto &t : b[r]) {
                size_t c = t.isCompileTimeConstant() ? 0 : map[t.exponent] + 1;
                B(r, c) = t.coefficient;
            }
            for (size_t c = 0; c < A.numCol(); ++c)
                B(r, c + 1 + numMonomials) = A(r, c);
        }
        // return ret;
        return Polyhedra<EmptyMatrix<int64_t>, SymbolicComparator>{
            std::move(B), EmptyMatrix<int64_t>{},
            SymbolicComparator::construct(b, std::move(poset))};
    }

    inline size_t getNumLoops() const { return getNumVar(); }
    AffineLoopNest(const IntMatrix &Ain, llvm::ArrayRef<MPoly> b,
                   PartiallyOrderedSet posetin)
        : Polyhedra{symbolicPolyhedra(Ain, b, std::move(posetin))} {
        pruneBounds();
    }
    AffineLoopNest(IntMatrix Ain, SymbolicComparator C)
        : Polyhedra<EmptyMatrix<int64_t>, SymbolicComparator>{
              .A = std::move(Ain),
              .E = EmptyMatrix<int64_t>{},
              .C = std::move(C)} {
        pruneBounds();
    }
    void removeLoopBang(size_t i) {
        fourierMotzkin(A, i + C.getNumConstTerms());
        pruneBounds();
    }
    AffineLoopNest removeLoop(size_t i) {
        AffineLoopNest L = *this;
        L.removeLoopBang(i);
        return L;
    }
    llvm::SmallVector<AffineLoopNest, 0> perm(llvm::ArrayRef<unsigned> x) {
        llvm::SmallVector<AffineLoopNest, 0> ret;
        ret.resize_for_overwrite(x.size());
        ret.back() = *this;
        for (size_t i = x.size() - 1; i != 0;) {
            AffineLoopNest &prev = ret[i];
            size_t oldi = i;
            ret[--i] = prev.removeLoop(x[oldi]);
        }
        return ret;
    }
    std::pair<IntMatrix, IntMatrix> bounds(size_t i) {
        const auto [numNeg, numPos] = countSigns(A, i);
        std::pair<IntMatrix, IntMatrix> ret;
        ret.first.resizeForOverwrite(numNeg, A.numCol());
        ret.second.resizeForOverwrite(numPos, A.numCol());
        size_t negCount = 0;
        size_t posCount = 0;
        for (size_t j = 0; j < A.numRow(); ++j) {
            if (int64_t Aji = A(j, i))
                (Aji < 0 ? ret.first : ret.second)
                    .copyRow(A.getRow(j), (Aji < 0 ? negCount++ : posCount++));
        }
        return ret;
    }
    llvm::SmallVector<std::pair<IntMatrix, IntMatrix>, 0>
    getBounds(llvm::ArrayRef<unsigned> x) {
        llvm::SmallVector<std::pair<IntMatrix, IntMatrix>, 0> ret;
        size_t i = x.size();
        ret.resize_for_overwrite(i);
        AffineLoopNest tmp = *this;
        while (true) {
            size_t xi = x[--i];
            ret[i] = tmp.bounds(xi);
            if (i == 0)
                break;
            tmp.removeLoopBang(xi);
        }
        return ret;
    }
    bool zeroExtraIterations(size_t _i, bool extendLower) {
        AffineLoopNest tmp{*this};
        const size_t numPrevLoops = getNumLoops() - 1;
        // for (size_t i = 0; i < numPrevLoops; ++i)
	    // if (_i != i)
		// tmp.removeLoopBang(i);
	
        for (size_t i = _i+1; i < numPrevLoops; ++i)
	    tmp.removeLoopBang(i);
	AffineLoopNest margi{tmp};
	margi.removeLoopBang(numPrevLoops);
	AffineLoopNest tmp2{tmp};
	// margi contains extrema for `_i`
	// we can substitute extended for value of `_i`
	// in `tmp`
	if (extendLower){
	    for (size_t c = 0; c < margi.getNumInequalityConstraints(); ++c){
		int64_t Aci = margi.A(c,_i);
		if (Aci < 0){
		    // c is lower bound
		    // now, define `i` to be equal to lower bound - 1
		}
	    }
	} else {
	    
	}
	return tmp.isEmpty();
        for (size_t i = 0; i < _i; ++i)
	    tmp.removeLoopBang(i);
        const size_t numCons = tmp.getNumInequalityConstraints();
        // get num upper and lower bounds for inner most loop
        for (size_t l = 0; l < numCons; ++l) {
	    int64_t Alj = tmp.A(l,numPrevLoops);
	    if (Alj <= 0)
		continue;
            for (size_t u = 0; u < numCons; ++u) {
		int64_t Auj = tmp.A(u,numPrevLoops);
		if (Auj >= 0)
		    continue;
		
            }
        }
	return true;
        // const auto [numNeg, numPos] = countSigns(A, numPrevLoops);
    }

    // void printBound(std::ostream &os, const IntMatrix &A, size_t i,
    void printBound(std::ostream &os, PtrMatrix<const int64_t> A, size_t i,
                    int64_t sign) const {

        const size_t numVar = getNumVar();
        const size_t numConst = C.getNumConstTerms();
        printVector(std::cout << "A.getRow(i) = ", A.getRow(i)) << std::endl;
        for (size_t j = 0; j < A.numRow(); ++j) {
            if (A(j, i + numConst) == sign) {
                if (sign < 0) {
                    os << "i_" << i << " >= ";
                } else {
                    os << "i_" << i << " <= ";
                }
            } else if (sign < 0) {
                os << sign * A(j, i + numConst) << "*i_" << i << " >= ";
            } else {
                os << sign * A(j, i + numConst) << "*i_" << i << " <= ";
            }
            llvm::ArrayRef<int64_t> b = getSymbol(A, j);
            bool printed = !allZero(b);
            if (printed)
                C.printSymbol(os, b, sign);
            for (size_t k = 0; k < numVar; ++k) {
                if (k == i)
                    continue;
                if (int64_t lakj = A(j, k + numConst)) {
                    if (lakj * sign > 0) {
                        os << " - ";
                    } else if (printed) {
                        os << " + ";
                    }
                    lakj = std::abs(lakj);
                    if (lakj != 1)
                        os << lakj << "*";
                    os << "i_" << k;
                    printed = true;
                }
            }
            if (!printed)
                os << 0;
            os << std::endl;
        }
    }
    // void printLowerBound(std::ostream &os, PtrMatrix<const int64_t> A, size_t i) const {
    //     printBound(os, A, i, -1);
    // }
    // void printUpperBound(std::ostream &os, PtrMatrix<const int64_t> A, size_t i) const {
    //     printBound(os, A, i, 1);
    // }
    friend std::ostream &operator<<(std::ostream &os,
                                    const AffineLoopNest &alnb) {
        const size_t numLoops = alnb.getNumVar();
        for (size_t _i = 0; _i < numLoops; ++_i) {
            os << "Variable " << _i << " lower bounds: " << std::endl;
            size_t i = alnb.currentToOriginalPerm(_i);
            alnb.printLowerBound(os, i);
            os << "Variable " << _i << " upper bounds: " << std::endl;
            alnb.printUpperBound(os, i);
        }
        return os;
    }
    void dump() const { std::cout << *this; }
};
