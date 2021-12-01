#pragma once
#include "math.hpp"
#include <cassert>
#include <cstddef>
#include <cstdint>
#include <limits>
#include <vector>
// A set of `size_t` elements.
// Initially constructed
struct BitSet {
    std::vector<std::uint64_t> data;
    size_t length;
    size_t operator[](size_t i) {
        return data[i];
    } // allow `getindex` but not `setindex`

    BitSet(size_t N) : length(0) {
        size_t len = (N + 63) >> 6;
        data.resize(len);
        for (size_t i = 0; i < len; ++i) {
            data[i] = 0;
        }
        // data = std::vector<std::uint64_t>(0, (N + 63) >> 6);
    }
    struct Iterator;
    Iterator begin();
    size_t end() { return length; };
};

struct BitSet::Iterator {
    std::vector<std::uint64_t> set;
    size_t didx;
    uint64_t offset; // offset with 64 bit block
    uint64_t state;
    size_t count;

    size_t operator*() { return offset + 64 * didx; }
    BitSet::Iterator &operator++() {
        ++count;
        while (state == 0) {
            ++didx;
            if (didx >= set.size())
                return *this;
            state = set[didx];
            offset = std::numeric_limits<uint64_t>::max();
            // offset = 0xffffffffffffffff;
        }
        size_t tzp1 = __builtin_ctz(state) + 1;
        offset += tzp1;
        state >>= tzp1;
        return *this;
    }
    bool operator!=(size_t x) { return count != x; }
    bool operator==(size_t x) { return count == x; }
    bool operator!=(BitSet::Iterator x) { return count != x.count; }
    bool operator==(BitSet::Iterator x) { return count == x.count; }
};
// BitSet::Iterator(std::vector<std::uint64_t> &seta)
//     : set(seta), didx(0), offset(0), state(seta[0]), count(0) {};
BitSet::Iterator construct(std::vector<std::uint64_t> &seta) {
    return BitSet::Iterator{seta, 0, std::numeric_limits<uint64_t>::max(),
                            seta[0], std::numeric_limits<uint64_t>::max()};
}

BitSet::Iterator BitSet::begin() { return ++construct(this->data); }

uint64_t contains(BitSet &s, size_t x) {
    size_t d = x >> size_t(6);
    uint64_t r = uint64_t(x) & uint64_t(63);
    uint64_t mask = uint64_t(1) << r;
    return (s.data[d] & (mask));
}

size_t length(BitSet s) { return s.length; }

bool push(BitSet &s, size_t x) {
    size_t d = x >> size_t(6);
    uint64_t r = uint64_t(x) & uint64_t(63);
    uint64_t mask = uint64_t(1) << r;
    bool contained = ((s.data[d] & mask) != 0);
    if (!contained) {
        s.data[d] |= (mask);
        ++(s.length);
    }
    return contained;
}

bool remove(BitSet &s, size_t x) {
    size_t d = x >> size_t(6);
    uint64_t r = uint64_t(x) & uint64_t(63);
    uint64_t mask = uint64_t(1) << r;
    bool contained = ((s.data[d] & mask) != 0);
    if (contained) {
        s.data[d] &= (~mask);
        --(s.length);
    }
    return contained;
}