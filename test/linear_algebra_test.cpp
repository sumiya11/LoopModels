#include "Math/LinearAlgebra.hpp"
#include "Math/Math.hpp"
#include <cstdint>
#include <gtest/gtest.h>
#include <iostream>
#include <random>

// NOLINTNEXTLINE(modernize-use-trailing-return-type)
TEST(LinearAlgebraTest, BasicAssertions) {
  const SquareMatrix<Rational> identity = SquareMatrix<Rational>::identity(4);
  SquareMatrix<int64_t> A(4);
  A(0, 0) = 2;
  A(0, 1) = -10;
  A(0, 2) = 6;
  A(0, 3) = -9;
  A(1, 0) = -10;
  A(1, 1) = 6;
  A(1, 2) = 5;
  A(1, 3) = -7;
  A(2, 0) = -1;
  A(2, 1) = -7;
  A(2, 2) = 0;
  A(2, 3) = 1;
  A(3, 0) = -8;
  A(3, 1) = 9;
  A(3, 2) = -2;
  A(3, 3) = 4;

  auto LUFopt = LU::fact(A);
  EXPECT_TRUE(LUFopt.has_value());
  assert(LUFopt.has_value());
  auto &LUF = *LUFopt;
  Matrix<Rational> B = A;
  llvm::errs() << "A = \n" << A << "\nB = \n" << B << "\n";
  llvm::errs() << LUF;

  auto Bcopy = B;
  EXPECT_FALSE(LUF.ldivrat(Bcopy));
  llvm::errs() << "LUF.ldiv(B) = \n" << Bcopy << "\n";
  EXPECT_TRUE(Bcopy == identity);
  llvm::errs() << "I = " << identity << "\n";

  EXPECT_FALSE(LUF.rdivrat(B));
  llvm::errs() << "LUF.rdiv(B) = \n" << B << "\n";
  EXPECT_TRUE(B == identity);
}

// NOLINTNEXTLINE(modernize-use-trailing-return-type)
TEST(DoubleLU, BasicAssertions) {
  SquareMatrix<double> A(4), B(4), C(4);
  std::mt19937 gen(0);
  for (size_t i = 0; i < 100; ++i) {
    for (auto &a : A) a = std::uniform_real_distribution<double>(-1, 1)(gen);
    for (auto &b : B) b = std::uniform_real_distribution<double>(-1, 1)(gen);
    C << B;
    // B = A \ B
    // C == A*B == A * (A \ B)
    LU::fact(A).ldiv(MutPtrMatrix<double>(B));
    EXPECT_TRUE(norm2(A * B - C) < 1e-10);
  }
}
