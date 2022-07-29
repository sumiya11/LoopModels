#include <iostream>
#include <gtest/gtest.h>
#include <memory>
#include "Comparators.hpp"
#include "MatrixStringParse.hpp"
//#include "../include/NormalForm.hpp"
#include "llvm/ADT/SmallVector.h"

TEST(BasicCompare, BasicAssertions) {
    
    // TEST full column rank case of A
    //IntMatrix A = stringToIntMatrix("[0 -1 0 1 0 0; 0 0 -1 1 0 0; 0 0 0 1 -1 0; 0 0 0 1 0 -1]");
    //IntMatrix A = stringToIntMatrix("[-1 0 1 0 0; 0 -1 1 0 0; 0 0 1 -1 0; 0 0 1 0 -1]");
    IntMatrix A = stringToIntMatrix("[-1 0 1 0 0; 0 -1 1 0 0; 0 0 -1 1 0; 0 0 -1 0 1]");
    auto comp = LinearSymbolicComparator::construct(std::move(A));
    llvm::SmallVector<int64_t, 16> query{-1, 0, 0, 1, 0};
    //llvm::SmallVector<int64_t, 16> query{1, 0, 0, -1, 0};
    EXPECT_TRUE(comp.greaterEqualZero(query));

    //TEST column deficient rank case of A
    IntMatrix A2 = stringToIntMatrix("[-1 0 1 0 0; 0 -1 1 0 0; 0 0 -1 1 0; 0 0 -1 0 1; -1 1 0 0 0; -1 0 0 1 0]");
    auto comp2 = LinearSymbolicComparator::construct(std::move(A2));
    llvm::SmallVector<int64_t, 16> query2{-1, 0, 0, 1, 0};
    llvm::SmallVector<int64_t, 16> query3{0, 0, 0, -1, 1};
    EXPECT_TRUE(comp2.greaterEqualZero(query2));
    EXPECT_TRUE(!comp2.greaterEqualZero(query3));
}

TEST(V2Matrix, BasicAssertions) {
    IntMatrix A = stringToIntMatrix("[0 -1 0 1 0 0; 0 0 -1 1 0 0; 0 0 0 1 -1 0; 0 0 0 1 0 -1]");
    //IntMatrix A = stringToIntMatrix(" [1 0 0 0 0 0 0 0 0 0 1 1; 0 1 0 0 0 0 0 0 0 0 -1 0; 0 0 1 0 0 0 0 0 0 0 0 1; 0 0 0 1 0 0 0 0 0 0 0 0; 0 0 0 0 1 0 0 0 0 0 -1 0; 0 0 0 0 0 1 0 0 0 0 0 -1; 0 0 0 0 0 0 1 0 0 0 1 1; 0 0 0 0 0 0 0 1 0 0 -1 0; 0 0 0 0 0 0 0 0 1 0 0 1; 0 0 0 0 0 0 0 0 0 1 0 0]");
    auto comp = LinearSymbolicComparator::construct(A);
    auto [H, U] = NormalForm::hermite(std::move(A));
    auto Ht = H.transpose();
    //std::cout << "Ht matrix:" << Ht << std::endl;
    auto Vt = IntMatrix::identity(Ht.numRow());
    auto NS = NormalForm::nullSpace(Ht);
    NormalForm::solveSystem(Ht, Vt);

    // std::cout << "Null space matrix:" << NS << std::endl;
    // std::cout << "Diagonal matrix:" << Ht << std::endl;
    // std::cout << "Transposed V matrix:" << Vt << std::endl;
    auto NSrow = NS.numRow();
    auto NScol = NS.numCol();
    auto offset = Vt.numRow() - NS.numRow();
    for (size_t i = 0; i < NSrow; ++i)
        for (size_t j = 0; j < NScol; ++j){
            EXPECT_EQ(NS(i, j), Vt(offset+i, j));}
}

TEST(TmpTest, BasicAssertions){
    IntMatrix A = stringToIntMatrix("[1 0 0 0 0 0 0 0 0 0 1 1; 0 1 0 0 0 0 0 0 0 0 -1 0; 0 0 1 0 0 0 0 0 0 0 0 1; 0 0 0 1 0 0 0 0 0 0 0 0; 0 0 0 0 1 0 0 0 0 0 -1 0; 0 0 0 0 0 1 0 0 0 0 0 -1; 0 0 0 0 0 0 1 0 0 0 1 1; 0 0 0 0 0 0 0 1 0 0 -1 0; 0 0 0 0 0 0 0 0 1 0 0 1; 0 0 0 0 0 0 0 0 0 1 0 0]");
    auto NS = NormalForm::nullSpace(A);
    std::cout<< NS <<std::endl;
}