#pragma once
#include "Math/AxisTypes.hpp"
#include "Math/MatrixDimensions.hpp"
#include "Utilities/Invariant.hpp"
#include "Utilities/Iterators.hpp"
#include "Utilities/Valid.hpp"
#include <cstddef>

namespace LinearAlgebra {

static inline constexpr struct Begin {
  friend inline auto operator<<(llvm::raw_ostream &os, Begin)
    -> llvm::raw_ostream & {
    return os << 0;
  }
} begin;
static inline constexpr struct End {
  friend inline auto operator<<(llvm::raw_ostream &os, End)
    -> llvm::raw_ostream & {
    return os << "end";
  }
} end;
struct OffsetBegin {
  [[no_unique_address]] size_t offset;
  friend inline auto operator<<(llvm::raw_ostream &os, OffsetBegin r)
    -> llvm::raw_ostream & {
    return os << r.offset;
  }
};
// FIXME: we currently lose strong typing of Row and Col when using relative
// indexing; we should preserve it, perhaps within the OffsetBegin row/struct,
// making them templated?
template <typename T>
concept ScalarValueIndex =
  std::integral<T> || std::same_as<T, Row> || std::same_as<T, Col>;

constexpr auto operator+(ScalarValueIndex auto x, Begin) -> OffsetBegin {
  return OffsetBegin{size_t(x)};
}
constexpr auto operator+(Begin, ScalarValueIndex auto x) -> OffsetBegin {
  return OffsetBegin{size_t(x)};
}
constexpr auto operator+(ScalarValueIndex auto x, OffsetBegin y)
  -> OffsetBegin {
  return OffsetBegin{size_t(x) + y.offset};
}
inline auto operator+(OffsetBegin y, ScalarValueIndex auto x) -> OffsetBegin {
  return OffsetBegin{size_t(x) + y.offset};
}
struct OffsetEnd {
  [[no_unique_address]] size_t offset;
  friend inline auto operator<<(llvm::raw_ostream &os, OffsetEnd r)
    -> llvm::raw_ostream & {
    return os << "end - " << r.offset;
  }
};
constexpr auto operator-(End, ScalarValueIndex auto x) -> OffsetEnd {
  return OffsetEnd{size_t(x)};
}
constexpr auto operator-(OffsetEnd y, ScalarValueIndex auto x) -> OffsetEnd {
  return OffsetEnd{y.offset + size_t(x)};
}
constexpr auto operator+(OffsetEnd y, ScalarValueIndex auto x) -> OffsetEnd {
  return OffsetEnd{y.offset - size_t(x)};
}
static constexpr inline OffsetEnd last{1};
template <typename T>
concept RelativeOffset = std::same_as<T, End> || std::same_as<T, OffsetEnd> ||
                         std::same_as<T, Begin> || std::same_as<T, OffsetBegin>;

// Union type
template <typename T>
concept ScalarRelativeIndex =
  std::same_as<T, End> || std::same_as<T, Begin> ||
  std::same_as<T, OffsetBegin> || std::same_as<T, OffsetEnd>;

template <typename T>
concept ScalarIndex = std::integral<T> || ScalarRelativeIndex<T>;

static inline constexpr struct Colon {
  [[nodiscard]] inline constexpr auto operator()(auto B, auto E) const {
    return Range{standardizeRangeBound(B), standardizeRangeBound(E)};
  }
} _; // NOLINT(bugprone-reserved-identifier)
constexpr auto canonicalize(size_t e, size_t) -> size_t { return e; }
constexpr auto canonicalize(Begin, size_t) -> size_t { return 0; }
constexpr auto canonicalize(OffsetBegin b, size_t) -> size_t {
  return b.offset;
}
constexpr auto canonicalize(End, size_t M) -> size_t { return M; }
constexpr auto canonicalize(OffsetEnd e, size_t M) -> size_t {
  return M - e.offset;
}
template <typename B, typename E>
constexpr auto canonicalizeRange(Range<B, E> r, size_t M)
  -> Range<size_t, size_t> {
  return Range<size_t, size_t>{canonicalize(r.b, M), canonicalize(r.e, M)};
}
constexpr auto canonicalizeRange(Colon, size_t M) -> Range<size_t, size_t> {
  return Range<size_t, size_t>{0, M};
}

#ifndef NDEBUG
inline void checkIndex(size_t X, size_t x) { assert(x < X); }
inline void checkIndex(size_t X, Begin) { assert(X > 0); }
inline void checkIndex(size_t X, OffsetEnd x) { assert((x.offset - 1) < X); }
inline void checkIndex(size_t X, OffsetBegin x) { assert(x.offset < X); }
inline void checkIndex(size_t X, Range<size_t, size_t> x) {
  assert(x.e >= x.b);
  assert(X >= x.e);
}
template <typename B, typename E>
inline void checkIndex(size_t M, Range<B, E> r) {
  checkIndex(M, canonicalizeRange(r, M));
}
inline void checkIndex(size_t, Colon) {}
#endif

template <typename T>
concept ScalarRowIndex = ScalarIndex<T> || std::same_as<T, Row>;
template <typename T>
concept ScalarColIndex = ScalarIndex<T> || std::same_as<T, Col>;

template <typename T>
constexpr inline auto matrixGet(NotNull<T> ptr, Row M, Col N, RowStride X,
                                const ScalarRowIndex auto mm,
                                const ScalarColIndex auto nn) -> T & {
  auto m = unwrapRow(mm);
  auto n = unwrapCol(nn);
#ifndef NDEBUG
  checkIndex(size_t(M), m);
  checkIndex(size_t(N), n);
#endif
  return *(ptr +
           size_t(canonicalize(n, size_t(N)) + X * canonicalize(m, size_t(M))));
}
template <typename T>
constexpr inline auto matrixGet(NotNull<const T> ptr, Row M, Col N, RowStride X,
                                const ScalarRowIndex auto mm,
                                const ScalarColIndex auto nn) -> const T & {
  auto m = unwrapRow(mm);
  auto n = unwrapCol(nn);
#ifndef NDEBUG
  checkIndex(size_t(M), m);
  checkIndex(size_t(N), n);
#endif
  return *(ptr +
           size_t(canonicalize(n, size_t(N)) + X * canonicalize(m, size_t(M))));
}
template <typename T> struct PtrVector;
template <typename T> struct MutPtrVector;
template <typename T> struct StridedVector;
template <typename T> struct MutStridedVector;
template <typename T, MatrixDimension D = StridedDims> struct PtrMatrix;
template <typename T, MatrixDimension D = StridedDims> struct MutPtrMatrix;

template <typename T>
concept AbstractSlice = requires(T t, size_t M) {
                          {
                            canonicalizeRange(t, M)
                            } -> std::same_as<Range<size_t, size_t>>;
                        };
static_assert(AbstractSlice<Range<size_t, size_t>>);
static_assert(AbstractSlice<Colon>);

template <typename T>
inline constexpr auto matrixGet(NotNull<const T> ptr, Row M, Col N, RowStride X,
                                const AbstractSlice auto m,
                                const AbstractSlice auto n)
  -> PtrMatrix<T, StridedDims> {
#ifndef NDEBUG
  checkIndex(size_t(M), m);
  checkIndex(size_t(N), n);
#endif
  Range<size_t, size_t> mr = canonicalizeRange(m, size_t(M));
  Range<size_t, size_t> nr = canonicalizeRange(n, size_t(N));
  return PtrMatrix{ptr + size_t(nr.b + X * mr.b),
                   StridedDims{mr.e - mr.b, nr.e - nr.b, X}};
}
template <typename T>
inline constexpr auto matrixGet(NotNull<T> ptr, Row M, Col N, RowStride X,
                                const AbstractSlice auto m,
                                const AbstractSlice auto n)
  -> MutPtrMatrix<T, StridedDims> {
#ifndef NDEBUG
  checkIndex(size_t(M), m);
  checkIndex(size_t(N), n);
#endif
  Range<size_t, size_t> mr = canonicalizeRange(m, size_t(M));
  Range<size_t, size_t> nr = canonicalizeRange(n, size_t(N));
  return MutPtrMatrix<T, StridedDims>{
    ptr + size_t(nr.b + X * mr.b),
    StridedDims{Row{mr.e - mr.b}, Col{nr.e - nr.b}, X}};
}

template <typename T>
inline constexpr auto matrixGet(NotNull<const T> ptr, Row M, Col N, RowStride X,
                                const ScalarRowIndex auto mm,
                                const AbstractSlice auto n) -> PtrVector<T> {
  auto m = unwrapRow(mm);
#ifndef NDEBUG
  checkIndex(size_t(M), m);
  checkIndex(size_t(N), n);
#endif
  size_t mi = canonicalize(m, size_t(M));
  Range<size_t, size_t> nr = canonicalizeRange(n, size_t(N));
  return PtrVector<T>{ptr + size_t(nr.b + X * mi), nr.e - nr.b};
}
template <typename T>
inline constexpr auto matrixGet(NotNull<T> ptr, Row M, Col N, RowStride X,
                                const ScalarRowIndex auto mm,
                                const AbstractSlice auto n) -> MutPtrVector<T> {
  auto m = unwrapRow(mm);
#ifndef NDEBUG
  checkIndex(size_t(M), m);
  checkIndex(size_t(N), n);
#endif
  size_t mi = canonicalize(m, size_t(M));
  Range<size_t, size_t> nr = canonicalizeRange(n, size_t(N));
  return MutPtrVector<T>{ptr + size_t(nr.b + X * mi), nr.e - nr.b};
}

template <typename T>
inline constexpr auto matrixGet(NotNull<const T> ptr, Row M, Col N, RowStride X,
                                const AbstractSlice auto m,
                                const ScalarColIndex auto nn)
  -> StridedVector<T> {
  auto n = unwrapCol(nn);
#ifndef NDEBUG
  checkIndex(size_t(M), m);
  checkIndex(size_t(N), n);
#endif
  Range<size_t, size_t> mr = canonicalizeRange(m, size_t(M));
  size_t ni = canonicalize(n, size_t(N));
  return StridedVector<T>{ptr + size_t(ni + X * mr.b), mr.e - mr.b, X};
}
template <typename T>
inline constexpr auto matrixGet(NotNull<T> ptr, Row M, Col N, RowStride X,
                                const AbstractSlice auto m,
                                const ScalarColIndex auto nn)
  -> MutStridedVector<T> {
  auto n = unwrapCol(nn);
#ifndef NDEBUG
  checkIndex(size_t(M), m);
  checkIndex(size_t(N), n);
#endif
  Range<size_t, size_t> mr = canonicalizeRange(m, size_t(M));
  size_t ni = canonicalize(n, size_t(N));
  return MutStridedVector<T>{ptr + size_t(ni + X * mr.b), mr.e - mr.b, X};
}

[[nodiscard]] inline constexpr auto calcOffset(size_t len, size_t i) {
  invariant(i < len);
  return i;
}
// note that we don't check i.b < len because we want to allow
// empty ranges, and r.b <= r.e <= len is checked in calcNewDim.
template <std::integral B, class E>
constexpr auto calcOffset(size_t, Range<B, E> i) -> B {
  return i.b;
}
template <class E>
constexpr auto calcOffset(size_t, Range<Begin, E>) -> size_t {
  return 0;
}
template <class E>
constexpr auto calcOffset(size_t, Range<OffsetBegin, E> i) -> size_t {
  return i.b.offset;
}
constexpr auto calcOffset(size_t, Colon) -> size_t { return 0; }

template <class R, class C>
[[nodiscard]] inline constexpr auto calcOffset(StridedDims d,
                                               CartesianIndex<R, C> i)
  -> size_t {
  return RowStride{d} * calcOffset(size_t(Row{d}), i.row) +
         calcOffset(size_t(Col{d}), i.col);
}

struct StridedRange {
  [[no_unique_address]] unsigned len;
  [[no_unique_address]] unsigned stride;
};
template <class I> constexpr auto calcOffset(StridedRange d, I i) -> size_t {
  return d.stride * calcOffset(d.len, i);
};

constexpr void calcNewDim(size_t, size_t){};
template <class B, class E>
constexpr auto calcNewDim(size_t len, Range<B, E> r) {
  return calcNewDim(len, canonicalizeRange(r, len));
};
constexpr auto calcNewDim(size_t len, Range<size_t, size_t> r) {
  invariant(r.e <= len);
  invariant(r.b <= r.e);
  return r.e - r.b;
};
template <std::integral R, std::integral C>
constexpr void calcNewDim(StridedDims, CartesianIndex<R, C>) {}
constexpr auto calcNewDim(std::integral auto len, Colon) { return len; };

template <AbstractSlice B, std::integral C>
constexpr auto calcNewDim(StridedDims d, CartesianIndex<B, C> i) {
  auto rowDims = calcNewDim(size_t(Row{d}), i.row);
  return StridedRange{rowDims, RowStride{d}};
}

template <std::integral R, AbstractSlice C>
constexpr auto calcNewDim(StridedDims d, CartesianIndex<R, C> i) {
  return calcNewDim(size_t(Col{d}), i.col);
}

template <AbstractSlice B, AbstractSlice C>
constexpr auto calcNewDim(StridedDims d, CartesianIndex<B, C> i) {
  auto rowDims = calcNewDim(size_t(Row{d}), i.row);
  auto colDims = calcNewDim(size_t(Col{d}), i.col);
  return StridedDims{Row{rowDims}, Col{colDims}, RowStride{d}};
}
template <AbstractSlice B>
constexpr auto calcNewDim(DenseDims d, CartesianIndex<B, Colon> i) {
  auto rowDims = calcNewDim(size_t(Row{d}), i.row);
  return DenseDims{Row{rowDims}, Col{d}};
}

} // namespace LinearAlgebra
