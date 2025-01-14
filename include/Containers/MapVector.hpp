#pragma once

#include "Containers/BumpMapSet.hpp"
#include "Math/BumpVector.hpp"
#include "Utilities/Allocators.hpp"

template <class K, class V> class MapVector {
  amap<K, size_t> map;
  LinAlg::BumpPtrVector<std::pair<K, V>> vector;

public:
  constexpr MapVector(BumpAlloc<> &alloc) : map(alloc), vector(alloc) {}
  MapVector(const MapVector &) = default;
  MapVector(MapVector &&) = default;
  constexpr MapVector &operator=(const MapVector &) = default;
  constexpr MapVector &operator=(MapVector &&) = default;
  constexpr auto find(const K &key) const {
    auto f = map.find(key);
    if (f == map.end()) return vector.end();
    return vector.begin() + f->second;
  }
  constexpr auto find(const K &key) {
    auto f = map.find(key);
    if (f == map.end()) return vector.end();
    return vector.begin() + f->second;
  }
  constexpr auto begin() const { return vector.begin(); }
  constexpr auto end() const { return vector.end(); }
  constexpr auto begin() { return vector.begin(); }
  constexpr auto end() { return vector.end(); }
  constexpr auto rbegin() const { return vector.rbegin(); }
  constexpr auto rend() const { return vector.rend(); }
  constexpr auto rbegin() { return vector.rbegin(); }
  constexpr auto rend() { return vector.rend(); }
  constexpr auto &operator[](const K &key) {
    auto f = map.find(key);
    if (f == map.end()) {
      auto i = vector.size();
      map[key] = i;
      vector.emplace_back(key, V());
      return vector[i].second;
    }
    return vector[f->second].second;
  }
  constexpr auto size() const { return vector.size(); }
  constexpr auto empty() const { return vector.empty(); }
  constexpr auto &back() { return vector.back(); }
  constexpr auto &back() const { return vector.back(); }
  constexpr auto &front() { return vector.front(); }
  constexpr auto &front() const { return vector.front(); }
  constexpr void insert(const K &key, const V &value) {
    auto f = map.find(key);
    if (f == map.end()) {
      auto i = vector.size();
      map[key] = i;
      vector.emplace_back(key, value);
    } else {
      vector[f->second].second = value;
    }
  }
  constexpr void insert(std::pair<K, V> &&value) {
    auto f = map.find(value.first);
    if (f == map.end()) {
      auto i = vector.size();
      map[value.first] = i;
      vector.emplace_back(std::move(value));
    } else {
      vector[f->second].second = std::move(value.second);
    }
  }
  constexpr void clear() {
    map.clear();
    vector.clear();
  }
  constexpr size_t count(const K &key) const { return map.count(key); }
};
