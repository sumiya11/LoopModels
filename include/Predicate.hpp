#pragma once
#include "Containers/BitSets.hpp"
#include "Math/BumpVector.hpp"
#include "Math/Math.hpp"
#include "Utilities/Allocators.hpp"
#include <cstddef>
#include <cstdint>
#include <cwchar>

#include <llvm/ADT/SmallPtrSet.h>
#include <llvm/ADT/SmallVector.h>
#include <llvm/IR/BasicBlock.h>
#include <llvm/IR/Instruction.h>
#include <llvm/IR/Value.h>
#include <llvm/Pass.h>
#include <llvm/Support/Allocator.h>
#include <variant>

struct Instruction;

namespace Predicate {
enum struct Relation : uint8_t {
  Any = 0,
  True = 1,
  False = 2,
  Empty = 3,
};

constexpr auto operator&(Relation a, Relation b) -> Relation {
  return static_cast<Relation>(static_cast<uint8_t>(a) |
                               static_cast<uint8_t>(b));
}
constexpr auto operator|(Relation a, Relation b) -> Relation {
  return static_cast<Relation>(static_cast<uint8_t>(a) &
                               static_cast<uint8_t>(b));
}

/// Predicate::Intersection
/// Represents the intersection of up to 32 predicates.
/// These are represented by a 64-bit unsigned integer, which is interpreted as
/// a vector of 32 `Predicate::Relation`s. The specific instructions these
/// correspond to are stored in an ordered container.
struct Intersection {
  [[no_unique_address]] uint64_t predicates;
  constexpr Intersection() = default;
  constexpr Intersection(uint64_t pred) : predicates(pred) {}
  constexpr Intersection(size_t index, Relation value)
    : predicates(static_cast<uint64_t>(value) << (2 * index)) {}
  constexpr auto operator[](size_t index) const -> Relation {
    assert(index < 32);
    return static_cast<Relation>((predicates >> (2 * (index))) & 3);
  }
  void set(size_t index, Relation value) {
    assert(index < 32);
    index += index;
    uint64_t maskedOff = predicates & ~(3ULL << (index));
    predicates = maskedOff | static_cast<uint64_t>(value) << (index);
  }
  [[nodiscard]] auto intersect(size_t index, Relation value) const
    -> Intersection {
    assert(index < 32);
    index += index;
    return {predicates | static_cast<uint64_t>(value) << (index)};
  }
  struct Reference {
    [[no_unique_address]] uint64_t &rp;
    [[no_unique_address]] size_t index;
    operator Relation() const { return static_cast<Relation>(rp >> index); }
    auto operator=(Relation relation) -> Reference & {
      this->rp =
        (this->rp & ~(3 << index)) | (static_cast<uint64_t>(relation) << index);
      return *this;
    }
  };
  [[nodiscard]] auto operator[](size_t index) -> Reference {
    return {predicates, 2 * index};
  }
  [[nodiscard]] constexpr auto operator&(Intersection other) const
    -> Intersection {
    return {predicates | other.predicates};
  }
  auto operator&=(Intersection other) -> Intersection & {
    predicates |= other.predicates;
    return *this;
  }
  [[nodiscard]] constexpr auto popCount() const -> size_t {
    return std::popcount(predicates);
  }
  [[nodiscard]] constexpr auto getFirstIndex() const -> size_t {
    return std::countr_zero(predicates) / 2;
  }
  [[nodiscard]] constexpr auto getNextIndex(size_t i) const -> size_t {
    ++i;
    return std::countr_zero(predicates >> (2 * i)) / 2 + i;
  }
  /// returns 00 if non-empty, 01 if empty
  [[nodiscard]] static constexpr auto emptyMask(uint64_t x) -> uint64_t {
    return ((x & (x >> 1)) & 0x5555555555555555);
  }
  /// returns 11 if non-empty, 00 if empty
  [[nodiscard]] static constexpr auto keepEmptyMask(uint64_t x) -> uint64_t {
    uint64_t y = emptyMask(x);
    return (y | (y << 1));
  }
  /// returns 11 if non-empty, 00 if empty
  [[nodiscard]] static constexpr auto removeEmptyMask(uint64_t x) -> uint64_t {
    return ~keepEmptyMask(x);
  }
  [[nodiscard]] static constexpr auto isEmpty(uint64_t x) -> bool {
    return emptyMask(x) != 0;
  }
  /// returns `true` if the PredicateIntersection is empty, `false` otherwise
  [[nodiscard]] constexpr auto isEmpty() const -> bool {
    return isEmpty(predicates);
  }
  [[nodiscard]] constexpr auto getConflict(Intersection other) const
    -> Intersection {
    uint64_t m = keepEmptyMask(predicates & other.predicates);
    return Intersection{predicates & m};
  }
  [[nodiscard]] constexpr auto countTrue() const {
    return std::popcount(predicates & 0x5555555555555555);
  }
  [[nodiscard]] constexpr auto countFalse() const {
    return std::popcount(predicates & 0xAAAAAAAAAAAAAAAA);
  }

  /// if the union between `this` and `other` can be expressed as an
  /// intersection of their constituents, return that intersection. Return an
  /// empty optional otherwise. The cases we handle are:
  /// (a & b) | a = a
  /// (a & b) | (a & !b) = a
  [[nodiscard]] constexpr auto compactUnion(Intersection other) const
    -> std::variant<std::monostate, Intersection,
                    std::pair<Intersection, Intersection>> {
    if (isEmpty()) return other;
    if (other.isEmpty()) return *this;
    uint64_t x = predicates, y = other.predicates;
    // 010000 = 010100 & 010000
    uint64_t intersect = x & y;
    if (x == intersect || y == intersect) return Intersection{intersect};
    // 011100 = 010100 | 011000
    // 010000 = 010100 & 011000
    // we can't handle (a & b) | (a & !b & c) because
    // (a & b) | (a & !b & c) = a & (b | c)) = (a & b) | (a & c)
    // bit representation:
    // 010000 = 010100 & 011001
    // we thus check all bits equal after masking off `b`.
    // We could consider returning a pair of options, so we can return the
    // simplified expression.
    uint64_t bitUnion = x | y;
    uint64_t mask = emptyMask(bitUnion);
    if (std::popcount(mask) == 1) { // a single b & !b case
      uint64_t remUnionMask =
        ~(mask | (mask << 1)); // 0s `b`, meaning b can be either.
      uint64_t w = remUnionMask & x;
      uint64_t z = remUnionMask & y;
      if (w == z) return Intersection{w};
      // if we now have
      //  a     |  a & c
      // 010000 | 010001
      uint64_t wz = w & z;
      if (wz == w) return std::make_pair(*this, Intersection{z});
      if (wz == z) return std::make_pair(Intersection{w}, other);
    }
    return {};
  }
}; // struct Predicate::Intersection

/// Predicate::Set
/// A type for performing set algebra on predicates, representing sets
/// Note:
/// Commutative:
///     a | b == b | a
///     a & b == b & a
/// Distributive:
///     a | (b & c) == (a | b) & (a | c)
///     a & (b | c) == (a & b) | (a & c)
/// Associative:
///    a | (b | c) == (a | b) | c
///    a & (b & c) == (a & b) & c
/// Idempotent:
///    a | a == a
///    a & a == a
/// The internal representation can be interpreted as the intersection
/// of a vector of predicates.
/// This makes intersection operations efficient, but means we
/// may need to allocate new instructions to represent unions.
/// Unions are needed for merging divergent control flow branches.
/// For union calculation, we'd simplify:
/// (a & b) | (a & c) == a & (b | c)
/// If c == !b, then
/// (a & b) | (a & !b) == a & (b | !b) == a & True == a
/// Generically:
/// (a & b) | (c & d) == ((a & b) | c) & ((a & b) | d)
/// == (a | c) & (b | c) & (a | d) & (b | d)
struct Set {
  [[no_unique_address]] LinAlg::BumpPtrVector<Intersection> intersectUnion;
  Set(BumpAlloc<> &alloc) : intersectUnion(alloc) {}
  Set(BumpAlloc<> &alloc, Intersection pred) : intersectUnion(alloc) {
    intersectUnion.push_back(pred);
  }
  Set(const Set &) = default;
  Set(Set &&) = default;
  auto operator=(Set &&other) noexcept -> Set & {
    intersectUnion = std::move(other.intersectUnion);
    return *this;
  };
  auto operator=(const Set &other) -> Set & = default;
  // TODO: constexpr these when llvm::SmallVector supports it
  [[nodiscard]] auto operator[](size_t index) -> Intersection {
    return intersectUnion[index];
  }
  [[nodiscard]] auto operator[](size_t index) const -> Intersection {
    return intersectUnion[index];
  }
  [[nodiscard]] auto operator()(size_t i, size_t j) const -> Relation {
    return intersectUnion[i][j];
  }
  [[nodiscard]] auto size() const -> size_t { return intersectUnion.size(); }
  /// Cases we simplify:
  /// a | {} = a
  /// Impl: if either empty, set to other
  /// a | (a & b) == a & (a | b) == a
  /// Impl: if one is super set of other, set to subset
  /// (a & b) | (a & !b) == a
  /// Impl: if exactly one full intersection, zero that cond, check if
  /// remaining match, if so, set to remaining.
  /// (a & b) | !b == a | !b
  /// Impl: if one contains only one cond, drop that cond if it's reversed in
  /// other.
  /// Currently, it should be able to simplify:
  /// *this U other, where
  /// *this = (a & !b & c) | (a & !c)
  /// other = (a & b)
  /// to:
  /// (a & b) | (a & c) | (a & !c) = (a & b) | a = a
  /// TODO: handle more cases? Smarter algorithm that applies rewrite rules?
  auto operator|=(Intersection other) -> Set & {
    if (other.isEmpty()) return *this;
    if (intersectUnion.empty()) {
      intersectUnion.push_back(other);
      return *this;
    }
    // we first try to avoid pushing so that we don't have to realloc
    bool simplifyPreds = false;
    for (auto &&pred : intersectUnion) {
      auto u = pred.compactUnion(other);
      if (auto *compact = std::get_if<Intersection>(&u)) {
        pred = *compact;
        return *this;
      }
      if (auto *simplify =
            std::get_if<std::pair<Intersection, Intersection>>(&u)) {
        pred = simplify->first;
        other = simplify->second;
        simplifyPreds = true;
      }
    }
    intersectUnion.push_back(other);
    while (simplifyPreds) {
      simplifyPreds = false;
      for (size_t i = 0; i < intersectUnion.size(); ++i) {
        for (size_t j = i + 1; j < intersectUnion.size();) {
          auto u = intersectUnion[i].compactUnion(intersectUnion[j]);
          if (auto *compact = std::get_if<Intersection>(&u)) {
            // delete `j`, update `i`
            intersectUnion[i] = *compact;
            intersectUnion.erase(intersectUnion.begin() + j);
            simplifyPreds = true;
          } else {
            if (auto *simplify =
                  std::get_if<std::pair<Intersection, Intersection>>(&u)) {
              // assert forward progress
              assert((std::popcount(simplify->first.predicates) +
                      std::popcount(simplify->second.predicates)) <=
                     (std::popcount(intersectUnion[i].predicates) +
                      std::popcount(intersectUnion[j].predicates)));
              intersectUnion[i] = simplify->first;
              intersectUnion[j] = simplify->second;
              simplifyPreds = true;
            }
            ++j;
          }
        }
      }
    }
    return *this;
  }
  /// if *this = [(a & b) | (c & d)]
  /// and other = [(e & f) | (g & h)]
  /// then
  /// [(a & b) | (c & d)] | [(e & f) | (g & h)] =
  ///   [(a & b) | (c & d) | (e & f) | (g & h)]
  auto operator|=(const Set &other) -> Set & {
    if (intersectUnion.empty()) intersectUnion = other.intersectUnion;
    else
      for (auto &&pred : other.intersectUnion) *this |= pred;
    return *this;
  }
  [[nodiscard]] auto operator|(Intersection other) const & -> Set {
    auto ret = *this;
    ret |= other;
    return ret;
  }
  [[nodiscard]] auto operator|(Intersection other) && -> Set {
    return std::move(*this |= other);
  }
  [[nodiscard]] auto operator|(Set other) const & -> Set {
    return other |= *this;
  }
  [[nodiscard]] auto operator|(const Set &other) && -> Set {
    return std::move(*this |= other);
  }
  auto operator&=(Intersection pred) -> Set & {
    for (size_t i = 0; i < intersectUnion.size();) {
      intersectUnion[i] &= pred;
      if (intersectUnion[i].isEmpty())
        intersectUnion.erase(intersectUnion.begin() + i);
      else ++i;
    }
    return *this;
  }
  // TODO: `constexpr` once `llvm::SmallVector` supports it
  [[nodiscard]] auto begin() { return intersectUnion.begin(); }
  [[nodiscard]] auto end() { return intersectUnion.end(); }
  [[nodiscard]] auto begin() const { return intersectUnion.begin(); }
  [[nodiscard]] auto end() const { return intersectUnion.end(); }
  [[nodiscard]] auto operator&=(Set &pred) -> Set & {
    for (auto p : pred) (*this) &= p;
    return *this;
  }
  [[nodiscard]] auto isEmpty() const -> bool { return intersectUnion.empty(); }
  [[nodiscard]] auto intersect(BumpAlloc<> &alloc, const Set &other) const {
    Set ret{alloc};
    for (auto &&pred : intersectUnion)
      for (auto &&otherPred : other) ret |= pred & otherPred;
    return ret;
  }
  /// returns a pair intersections
  [[nodiscard]] auto getConflict(const Set &other) -> Intersection {
    assert(intersectionIsEmpty(other));
    Intersection ret;
    for (auto pred : intersectUnion) {
      for (auto otherPred : other) {
        assert((pred & otherPred).isEmpty());
        ret &= pred.getConflict(otherPred);
      }
    }
    return ret;
  }
  /// intersectionIsEmpty(const Set &other) -> bool
  /// returns `true` if the intersection of `*this` and `other` is empty
  /// if *this = [(a & b) | (c & d)]
  ///    other = [(e & f) | (g & h)]
  /// then
  /// [(a & b) | (c & d)] & [(e & f) | (g & h)] =
  ///   [(a & b) & (e & f)] |
  ///   [(a & b) & (g & h)] |
  ///   [(c & d) & (e & f)] |
  ///   [(c & d) & (g & h)]
  /// So iterating over the union elements, if any of them are not empty, then
  /// the intersection is not empty.
  [[nodiscard]] auto intersectionIsEmpty(const Set &other) const -> bool {
    for (auto pred : intersectUnion)
      for (auto otherPred : other)
        if (!((pred & otherPred).isEmpty())) return false;
    return true;
  }

  // static auto getIndex(llvm::SmallVectorImpl<Instruction *> &instructions,
  //                      Instruction *instruction) -> size_t {
  //     size_t I = instructions.size();
  //     for (size_t i = 0; i < I; i++)
  //         if (instructions[i] == instruction)
  //             return i;
  //     instructions.push_back(instruction);
  //     return I;
  // }
  // PredicateSet() = default;
  // PredicateSet(BumpAlloc<> &alloc, Instruction::Cache
  // &ic,
  //                    llvm::SmallVector<Instruction *> &predicates,
  //                    Predicates &pred) {
  //     for (Predicate &p : pred) {
  //         Instruction *i = ic.get(alloc, p.condition);
  //         size_t index = getIndex(predicates, i);
  //         PredicateRelation val =
  //             p.flip ? PredicateRelation::False :
  //             PredicateRelation::True;
  //         set(index, val);
  //     }
  // }
}; // struct Predicate::Set

struct Map;
}; // namespace Predicate
