#pragma once
#include "./Rational.hpp"
#include "Math/Constructors.hpp"
#include "Math/Math.hpp"
#include "Utilities/Invariant.hpp"

struct LU {
  SquareMatrix<Rational> F;
  Vector<unsigned> ipiv;

  [[nodiscard]] constexpr auto ldiv(MutPtrMatrix<Rational> rhs) const -> bool {
    auto [M, N] = rhs.size();
    assert(F.numRow() == M);
    // // check unimodularity
    // Rational unit = 1;
    // for (size_t i = 0; i < FM; ++i)
    //     unit *= F(i, i);
    // assert(unit == 1);

    // permute rhs
    for (size_t i = 0; i < M; ++i) {
      unsigned ip = ipiv[i];
      if (i != ip)
        for (size_t j = 0; j < M; ++j) std::swap(rhs(ip, j), rhs(i, j));
    }
    // LU x = rhs
    // L y = rhs // L is UnitLowerTriangular
    for (size_t n = 0; n < N; ++n) {
      for (size_t m = 0; m < M; ++m) {
        Rational Ymn = rhs(m, n);
        for (size_t k = 0; k < m; ++k)
          if (Ymn.fnmadd(F(m, k), rhs(k, n))) return true;
        rhs(m, n) = Ymn;
      }
    }
    // U x = y
    for (size_t n = 0; n < N; ++n) {
      for (auto m = size_t(M); m--;) {
        Rational Ymn = rhs(m, n);
        for (size_t k = m + 1; k < M; ++k)
          if (Ymn.fnmadd(F(m, k), rhs(k, n))) return true;
        if (auto div = Ymn.safeDiv(F(m, m))) rhs(m, n) = *div;
        else return true;
      }
    }
    return false;
  }
  template <typename T> constexpr void ldiv(MutPtrMatrix<T> rhs) const {
    auto [M, N] = rhs.size();
    assert(F.numRow() == M);
    // // check unimodularity
    // Rational unit = 1;
    // for (size_t i = 0; i < FM; ++i)
    //     unit *= F(i, i);
    // assert(unit == 1);

    // permute rhs
    for (size_t i = 0; i < M; ++i) {
      unsigned ip = ipiv[i];
      if (i != ip)
        for (size_t j = 0; j < M; ++j) std::swap(rhs(ip, j), rhs(i, j));
    }
    // LU x = rhs
    // L y = rhs // L is UnitLowerTriangular
    for (size_t n = 0; n < N; ++n) {
      for (size_t m = 0; m < M; ++m) {
        T Ymn = rhs(m, n);
        for (size_t k = 0; k < m; ++k) Ymn -= F(m, k) * rhs(k, n);
        rhs(m, n) = Ymn;
      }
    }
    // U x = y
    for (size_t n = 0; n < N; ++n) {
      for (auto m = size_t(M); m--;) {
        T Ymn = rhs(m, n);
        for (size_t k = m + 1; k < M; ++k) Ymn -= F(m, k) * rhs(k, n);
        rhs(m, n) = Ymn / F(m, m);
      }
    }
  }

  [[nodiscard]] constexpr auto rdiv(MutPtrMatrix<Rational> rhs) const -> bool {
    auto [M, N] = rhs.size();
    assert(F.numCol() == N);
    // // check unimodularity
    // Rational unit = 1;
    // for (size_t i = 0; i < FN; ++i)
    //     unit *= F(i, i);
    // assert(unit == 1);

    // PA = LU
    // x LU = rhs
    // y U = rhs
    for (size_t n = 0; n < N; ++n) {
      for (size_t m = 0; m < M; ++m) {
        Rational Ymn = rhs(m, n);
        for (size_t k = 0; k < n; ++k)
          if (Ymn.fnmadd(rhs(m, k), F(k, n))) return true;
        if (auto div = Ymn.safeDiv(F(n, n))) rhs(m, n) = *div;
        else return true;
      }
    }
    // x L = y
    for (auto n = size_t(N); n--;) {
      // for (size_t n = 0; n < N; ++n) {
      for (size_t m = 0; m < M; ++m) {
        Rational Xmn = rhs(m, n);
        for (size_t k = n + 1; k < N; ++k)
          if (Xmn.fnmadd(rhs(m, k), F(k, n))) return true;
        rhs(m, n) = Xmn;
      }
    }
    // permute rhs
    for (auto j = size_t(N); j--;) {
      unsigned jp = ipiv[j];
      if (j != jp)
        for (size_t i = 0; i < M; ++i) std::swap(rhs(i, jp), rhs(i, j));
    }

    return false;
  }
  template <typename T> constexpr void rdiv(MutPtrMatrix<Rational> rhs) const {
    auto [M, N] = rhs.size();
    assert(F.numCol() == N);
    // // check unimodularity
    // Rational unit = 1;
    // for (size_t i = 0; i < FN; ++i)
    //     unit *= F(i, i);
    // assert(unit == 1);

    // PA = LU
    // x LU = rhs
    // y U = rhs
    for (size_t n = 0; n < N; ++n) {
      for (size_t m = 0; m < M; ++m) {
        T Ymn = rhs(m, n);
        for (size_t k = 0; k < n; ++k) Ymn -= rhs(m, k) * F(k, n);
        rhs(m, n) = Ymn / F(n, n);
      }
    }
    // x L = y
    for (auto n = size_t(N); n--;) {
      // for (size_t n = 0; n < N; ++n) {
      for (size_t m = 0; m < M; ++m) {
        T Xmn = rhs(m, n);
        for (size_t k = n + 1; k < N; ++k) Xmn -= rhs(m, k) * F(k, n);
        rhs(m, n) = Xmn;
      }
    }
    // permute rhs
    for (auto j = size_t(N); j--;) {
      unsigned jp = ipiv[j];
      if (j != jp)
        for (size_t i = 0; i < M; ++i) std::swap(rhs(i, jp), rhs(i, j));
    }
  }

  [[nodiscard]] constexpr auto inv() const
    -> std::optional<SquareMatrix<Rational>> {
    SquareMatrix<Rational> A{
      SquareMatrix<Rational>::identity(size_t(F.numCol()))};
    if (!ldiv(A)) return A;
    return {};
  }
  [[nodiscard]] constexpr auto det() const -> std::optional<Rational> {
    Rational d = F(0, 0);
    for (size_t i = 1; i < F.numCol(); ++i)
      if (auto di = d.safeMul(F(i, i))) d = *di;
      else return {};
    return d;
  }
  [[nodiscard]] constexpr auto perm() const -> Vector<unsigned> {
    Col M = F.numCol();
    Vector<unsigned> perm;
    for (size_t m = 0; m < M; ++m) perm.push_back(m);
    for (size_t m = 0; m < M; ++m) std::swap(perm[m], perm[ipiv[m]]);
    return perm;
  }
  [[nodiscard]] static constexpr auto fact(const SquareMatrix<int64_t> &B)
    -> std::optional<LU> {
    Row M = B.numRow();
    SquareMatrix<Rational> A(B);
    // auto ipiv = Vector<unsigned>{.s = unsigned(M)};
    auto ipiv{vector(std::allocator<unsigned>{}, unsigned(M))};
    // Vector<unsigned> ipiv{.s = unsigned(M)};
    invariant(size_t(ipiv.size()), size_t(M));
    for (size_t i = 0; i < M; ++i) ipiv[i] = i;
    for (size_t k = 0; k < M; ++k) {
      size_t kp = k;
      for (; kp < M; ++kp) {
        if (A(kp, k) != 0) {
          ipiv[k] = kp;
          break;
        }
      }
      if (kp != k)
        for (size_t j = 0; j < M; ++j) std::swap(A(kp, j), A(k, j));
      Rational Akkinv = A(k, k).inv();
      for (size_t i = k + 1; i < M; ++i)
        if (std::optional<Rational> Aik = A(i, k).safeMul(Akkinv))
          A(i, k) = *Aik;
        else return {};
      for (size_t j = k + 1; j < M; ++j) {
        for (size_t i = k + 1; i < M; ++i) {
          if (std::optional<Rational> Aikj = A(i, k).safeMul(A(k, j))) {
            if (std::optional<Rational> Aij = A(i, j).safeSub(*Aikj)) {
              A(i, j) = *Aij;
              continue;
            }
          }
          return {};
        }
      }
    }
    return LU{std::move(A), std::move(ipiv)};
  }
};
