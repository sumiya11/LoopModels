#pragma once

// #include "./ControlFlowMerging.hpp"
#include "./LoopBlock.hpp"
#include "./MemoryAccess.hpp"
#include "./Schedule.hpp"
#include "Address.hpp"
#include "Dependence.hpp"
#include "Graphs.hpp"
#include "Math/Array.hpp"
#include "Math/Math.hpp"
#include "Utilities/Allocators.hpp"
#include <algorithm>
#include <any>
#include <cassert>
#include <cstddef>
#include <cstdint>
#include <limits>
#include <llvm/ADT/ArrayRef.h>
#include <llvm/ADT/SmallPtrSet.h>
#include <llvm/ADT/SmallVector.h>
#include <llvm/Analysis/TargetTransformInfo.h>
#include <llvm/IR/BasicBlock.h>
#include <llvm/IR/Constant.h>
#include <llvm/IR/DerivedTypes.h>
#include <llvm/IR/Function.h>
#include <llvm/IR/Instruction.h>
#include <llvm/IR/LLVMContext.h>
#include <llvm/IR/Type.h>
#include <llvm/Support/Allocator.h>
#include <llvm/Support/raw_ostream.h>
#include <string_view>
#include <utility>

namespace CostModeling {

struct CPURegisterFile {
  [[no_unique_address]] uint8_t maximumVectorWidth;
  [[no_unique_address]] uint8_t numVectorRegisters;
  [[no_unique_address]] uint8_t numGeneralPurposeRegisters;
  [[no_unique_address]] uint8_t numPredicateRegisters;

  // hacky check for has AVX512
  static inline auto hasAVX512(llvm::LLVMContext &C,
                               llvm::TargetTransformInfo &TTI) -> bool {
    return TTI.isLegalMaskedExpandLoad(
      llvm::FixedVectorType::get(llvm::Type::getDoubleTy(C), 8));
  }

  static auto estimateNumPredicateRegisters(llvm::LLVMContext &C,
                                            llvm::TargetTransformInfo &TTI)
    -> uint8_t {
    if (TTI.supportsScalableVectors()) return 8;
    // hacky check for AVX512
    if (hasAVX512(C, TTI)) return 7; // 7, because k0 is reserved for unmasked
    return 0;
  }
  // returns vector width in bits
  static auto estimateMaximumVectorWidth(llvm::LLVMContext &C,
                                         llvm::TargetTransformInfo &TTI)
    -> uint8_t {
    uint8_t twiceMaxVectorWidth = 2;
    auto *f32 = llvm::Type::getFloatTy(C);
    llvm::InstructionCost prevCost = TTI.getArithmeticInstrCost(
      llvm::Instruction::FAdd,
      llvm::FixedVectorType::get(f32, twiceMaxVectorWidth));
    while (true) {
      llvm::InstructionCost nextCost = TTI.getArithmeticInstrCost(
        llvm::Instruction::FAdd,
        llvm::FixedVectorType::get(f32, twiceMaxVectorWidth *= 2));
      if (nextCost > prevCost) break;
      prevCost = nextCost;
    }
    return 16 * twiceMaxVectorWidth;
  }
  CPURegisterFile(llvm::LLVMContext &C, llvm::TargetTransformInfo &TTI) {
    maximumVectorWidth = estimateMaximumVectorWidth(C, TTI);
    numVectorRegisters = TTI.getNumberOfRegisters(true);
    numGeneralPurposeRegisters = TTI.getNumberOfRegisters(false);
    numPredicateRegisters = estimateNumPredicateRegisters(C, TTI);
  }
};
// struct CPUExecutionModel {};

// Plan for cost modeling:
// 1. Build Instruction graph
// 2. Iterate over all PredicatedChains, merging instructions across branches
// where possible
// 3. Create a loop tree structure for optimization
// 4. Create InstructionBlocks at each level.

// void pushBlock(llvm::SmallPtrSet<llvm::Instruction *, 32> &trackInstr,
//                llvm::SmallPtrSet<llvm::BasicBlock *, 32> &chainBBs,
//                Predicates &pred, llvm::BasicBlock *BB) {
//     assert(chainBBs.contains(block));
//     chainBBs.erase(BB);
//     // we only want to extract relevant instructions, i.e. parents of
//     stores for (llvm::Instruction &instr : *BB) {
//         if (trackInstr.contains(&instr))
//             instructions.emplace_back(pred, instr);
//     }
//     llvm::Instruction *term = BB->getTerminator();
//     if (!term)
//         return;
//     switch (term->getNumSuccessors()) {
//     case 0:
//         return;
//     case 1:
//         BB = term->getSuccessor(0);
//         if (chainBBs.contains(BB))
//             pushBlock(trackInstr, chainBBs, pred, BB);
//         return;
//     case 2:
//         break;
//     default:
//         assert(false);
//     }
//     auto succ0 = term->getSuccessor(0);
//     auto succ1 = term->getSuccessor(1);
//     if (chainBBs.contains(succ0) && chainBBs.contains(succ1)) {
//         // TODO: we need to fuse these blocks.

//     } else if (chainBBs.contains(succ0)) {
//         pushBlock(trackInstr, chainBBs, pred, succ0);
//     } else if (chainBBs.contains(succ1)) {
//         pushBlock(trackInstr, chainBBs, pred, succ1);
//     }
// }

/// Given: llvm::SmallVector<LoopAndExit> subTrees;
/// subTrees[i].second is the preheader for
/// subTrees[i+1].first, which has exit block
/// subTrees[i+1].second

/// Initialized from a LoopBlock
/// First, all memory accesses are placed.
///  - Topologically sort at the same level
///  - Hoist out as far as posible
/// Then, merge eligible loads.
///  - I.e., merge loads that are in the same block with same address and not
///  aliasing stores in between
/// Finally, place instructions, seeded by stores, hoisted as far out as
/// possible. With this, we can begin cost modeling.
class LoopTreeSchedule {
  template <typename T> using Vec = LinAlg::ResizeableView<T, unsigned>;
  using BitSet = MemoryAccess::BitSet;

public:
  struct AddressGraph {
    using VertexType = Address;
    [[no_unique_address]] MutPtrVector<Address *> addresses;
    // we restrict the SCC order to preserve relative ordering of the sub loops
    // by adding loopNestAddrs. These contain arrays of [start, stop].
    // Each start has the preceding end as an input.
    // Each stop has the following start as an output.
    // Each start also has the enclosed mem accesses as outputs,
    // and each stop has the enclosed mem accesses as inputs (enclosed means the
    // memory accesses of the corresponding loop).
    [[no_unique_address]] MutPtrVector<std::array<BitSet, 2>> loopNestAddrs;
    [[nodiscard]] constexpr auto maxVertexId() const -> unsigned {
      return addresses.size() + 2 * loopNestAddrs.size();
    }
    [[nodiscard]] constexpr auto vertexIds() const -> Range<size_t, size_t> {
      return _(0, maxVertexId());
    }
    [[nodiscard]] auto getNumVertices() const -> size_t {
      return addresses.size();
    }
    // Graph index ordering: LoopEnds, ArrayRefs, LoopStarts
    // so that we have ends as early as possible, and starts a late
    [[nodiscard]] constexpr auto inNeighbors(size_t i) const -> BitSet {
      if (i < loopNestAddrs.size()) return loopNestAddrs[i][1]; // loop end
      i -= loopNestAddrs.size();
      if (i < addresses.size()) return addresses[i]->getParents();
      return loopNestAddrs[i - addresses.size()][0]; // loop start
    }
    [[nodiscard]] auto wasVisited(size_t i) const -> bool {
      return addresses[i]->wasVisited();
    }
    void visit(size_t i) { addresses[i]->visit(); }
    void unVisit(size_t i) { addresses[i]->unVisit(); }
    void clearVisited() {
      for (auto *a : addresses) a->unVisit();
    }
  };

private:
  template <typename T>
  static constexpr auto realloc(BumpAlloc<> &alloc, Vec<T> vec, unsigned nc)
    -> Vec<T> {
    return Vec<T>(alloc.reallocate<false>(vec.data(), vec.getCapacity(), nc),
                  vec.size(), nc);
  }
  template <typename T>
  static constexpr auto grow(BumpAlloc<> &alloc, Vec<T> vec, unsigned sz)
    -> Vec<T> {
    if (unsigned C = vec.getCapacity(); C < sz) {
      T *p = alloc.allocate<T>(sz + sz);
      for (unsigned i = 0; i < vec.size(); ++i) p[i] = std::move(vec[i]);
      return Vec<T>(p, sz, sz + sz);
    }
    vec.resizeForOverwrite(sz);
    return vec;
  }

  class InstructionBlock {
    Address **addresses{nullptr};
    unsigned numAddr{0};
    unsigned capacity{0};

  public:
    [[nodiscard]] constexpr auto isInitialized() const -> bool {
      return addresses != nullptr;
    }
    [[nodiscard]] constexpr auto getAddr() -> PtrVector<Address *> {
      return {addresses, numAddr, capacity};
    }
    [[nodiscard]] constexpr auto size() const -> unsigned { return numAddr; }
    [[nodiscard]] constexpr auto getCapacity() const -> unsigned {
      return capacity;
    }
    [[nodiscard]] constexpr auto operator[](unsigned i) const -> Address * {
      invariant(i < numAddr);
      invariant(i < capacity);
      return addresses[i];
    }
    /// add space for `i` extra slots
    constexpr void reserveExtra(BumpAlloc<> &alloc, unsigned i) {
      unsigned oldCapacity = std::exchange(capacity, capacity + i);
      addresses = alloc.reallocate<false>(addresses, oldCapacity, capacity);
    }
    constexpr void initialize(BumpAlloc<> &alloc) {
      addresses = alloc.allocate<Address *>(capacity);
    }
    constexpr void push_back(Address *addr) {
      invariant(numAddr < capacity);
      addresses[numAddr++] = addr;
    }
    constexpr void push_back(BumpAlloc<> &alloc, Address *addr) {
      if (numAddr >= capacity)
        reserveExtra(alloc, std::max<unsigned>(4, numAddr));
      addresses[numAddr++] = addr;
    }
    constexpr void push_front(Address *addr) {
      invariant(numAddr < capacity);
      for (size_t i = 0; i < numAddr; ++i) {
        Address *tmp = addresses[i];
        addresses[i] = addr;
        addr = tmp;
      }
      addresses[numAddr++] = addr;
    }
    constexpr void push_front(BumpAlloc<> &alloc, Address *addr) {
      if (numAddr >= capacity)
        reserveExtra(alloc, std::max<unsigned>(4, numAddr));
      push_front(addr);
    }
    constexpr void incNumAddr(unsigned x) { capacity += x; }
    [[nodiscard]] constexpr auto try_delete(Address *adr) -> bool {
      for (size_t i = 0; i < numAddr; ++i) {
        if (addresses[i] == adr) {
          addresses[i] = addresses[--numAddr];
          return true;
        }
      }
      return false;
    }
    constexpr void clear() { numAddr = 0; }
    auto printDotNodes(llvm::raw_ostream &os, size_t i,
                       llvm::SmallVectorImpl<std::string> &addrNames,
                       unsigned addrIndOffset, const std::string &parentLoop)
      -> size_t {
      for (auto *addr : getAddr()) {
        std::string f("f" + std::to_string(++i)), addrName = "\"";
        addrName += parentLoop;
        addrName += "\":";
        addrName += f;
        unsigned ind = addr->index() -= addrIndOffset;
        addrNames[ind] = addrName;
        addr->printDotName(os << "<tr><td port=\"" << f << "\"> ");

        os << "</td></tr>\n";
      }
      return i;
    }

    void printDotEdges(llvm::raw_ostream &os,
                       llvm::ArrayRef<std::string> addrNames) {
      for (auto *addr : getAddr()) {
        auto outN{addr->outNeighbors()};
        auto depS{addr->outDepSat()};
        for (size_t n = 0; n < outN.size(); ++n) {
          os << addrNames[addr->index()] << " -> "
             << addrNames[outN[n]->index()];
          if (depS[n] == 255) os << " [color=\"#00ff00\"];\n";
          else if (depS[n] == 127) os << " [color=\"#008080\"];\n";
          else
            os << " [label = \"dep_sat=" << unsigned(depS[n])
               << "\", color=\"#0000ff\"];\n";
        }
      }
    }
  };

  struct LoopAndExit {
    [[no_unique_address]] LoopTreeSchedule *subTree;
    [[no_unique_address]] InstructionBlock exit{};
    constexpr LoopAndExit(LoopTreeSchedule *tree) : subTree(tree) {}
    static constexpr auto construct(BumpAlloc<> &alloc, LoopTreeSchedule *L,
                                    uint8_t d, uint8_t blockIdx) {
      return LoopAndExit(alloc.create<LoopTreeSchedule>(L, d, blockIdx));
    }
  };
  /// Header of the loop.
  [[no_unique_address]] InstructionBlock header{};
  /// Variable number of sub loops and their associated exits.
  /// For the inner most loop, `subTrees.empty()`.
  [[no_unique_address]] Vec<LoopAndExit> subTrees{};
  [[no_unique_address]] LoopTreeSchedule *parent{nullptr};
  [[no_unique_address]] uint8_t depth;
  [[no_unique_address]] uint8_t numAddr_;
  [[no_unique_address]] uint8_t blckIdx{0};
  // notused yet
  /*
  [[no_unique_address]] uint8_t vectorizationFactor{1};
  [[no_unique_address]] uint8_t unrollFactor{1};
  [[no_unique_address]] uint8_t unrollPredcedence{1};
  */
  // i = 0 means self, i = 1 (default) returns parent, i = 2 parent's
  // parent...
  constexpr auto try_delete(Address *adr) -> bool {
    return (adr->getLoopTreeSchedule() == this) &&
           getBlock(adr->getBlockIdx()).try_delete(adr);
  }
  // get index of block within parent
  [[nodiscard]] constexpr auto getBlockIdx() const -> unsigned {
    return blckIdx;
  }
  constexpr auto getParent(size_t i) -> LoopTreeSchedule * {
    invariant(i <= depth);
    LoopTreeSchedule *p = this;
    while (i--) p = p->parent;
    return p;
  }
  constexpr void incNumAddr(unsigned x) { header.incNumAddr(x); }
  constexpr auto getParent() -> LoopTreeSchedule * { return parent; }
  [[nodiscard]] constexpr auto getNumSubTrees() const -> unsigned {
    return subTrees.size();
  }
  [[nodiscard]] constexpr auto numBlocks() const -> unsigned {
    return getNumSubTrees() + 1;
  }
  constexpr auto getLoopAndExit(BumpAlloc<> &alloc, size_t i, size_t d)
    -> LoopAndExit & {
    if (size_t J = subTrees.size(); i >= J) {
      subTrees = grow(alloc, subTrees, i + 1);
      for (size_t j = J; j <= i; ++j)
        subTrees[j] = LoopAndExit::construct(alloc, this, d, j);
    }
    return subTrees[i];
  }
  auto getLoopTripple(size_t i)
    -> std::tuple<InstructionBlock &, LoopTreeSchedule *, InstructionBlock &> {
    auto loopAndExit = subTrees[i];
    if (i) return {subTrees[i - 1].exit, loopAndExit.subTree, loopAndExit.exit};
    return {header, loopAndExit.subTree, loopAndExit.exit};
  }
  auto getLoop(BumpAlloc<> &alloc, size_t i, uint8_t d) -> LoopTreeSchedule * {
    return getLoopAndExit(alloc, i, d).subTree;
  }
  auto getLoop(size_t i) -> LoopTreeSchedule * { return subTrees[i].subTree; }
  [[nodiscard]] auto getLoop(size_t i) const -> const LoopTreeSchedule * {
    return subTrees[i].subTree;
  }
  auto getBlock(size_t i) -> InstructionBlock & {
    if (i) return subTrees[i - 1].exit;
    return header;
  }
  [[nodiscard]] auto getBlock(size_t i) const -> const InstructionBlock & {
    if (i) return subTrees[i - 1].exit;
    return header;
  }
  /// Adds the schedule corresponding for the innermost loop.

  // this method descends
  // NOLINTNEXTLINE(misc-no-recursion)
  static auto allocLoopNodes(BumpAlloc<> &alloc, AffineSchedule sch,
                             LoopTreeSchedule *L) -> LoopTreeSchedule * {
    auto fO = sch.getFusionOmega();
    unsigned numLoops = sch.getNumLoops();
    invariant(fO.size() - 1, numLoops);
    for (size_t i = 0; i < numLoops; ++i) L = L->getLoop(alloc, fO[i], i + 1);
    return L;
  }
  static constexpr void
  calcLoopNestAddrs(Vector<std::array<BitSet, 2>> &loopRelatives,
                    MutPtrVector<Address *> loopAddrs, unsigned numAddr,
                    unsigned idx) {
    // TODO: only add dependencies for refs actually using the indvars
    BitSet headParents{}, exitParents{};
    unsigned indEnd = idx, indStart = loopRelatives.size() + indEnd + numAddr;
    // not first loop, connect headParents
    if (idx) headParents.insert(indStart - 1);
    bool empty = true;
    for (auto *a : loopAddrs) {
      // if (!a->dependsOnIndVars(depth)) continue;
      exitParents.insert(a->index());
      a->addParent(indStart);
      empty = false;
    }
    if (empty) exitParents.insert(indStart);
    loopRelatives[idx] = {headParents, exitParents};
  }
  // NOLINTNEXTLINE(misc-no-recursion)
  constexpr auto getLoopIdx(LoopTreeSchedule *L) const -> unsigned {
    LoopTreeSchedule *P = L->getParent();
    if (P == this) return L->getBlockIdx();
    return getLoopIdx(P);
  }
  constexpr auto getIdx(Address *a) const -> unsigned {
    if (a->getLoopTreeSchedule() == this) return 2 * a->getBlockIdx();
    return 2 * getLoopIdx(a->getLoopTreeSchedule()) + 1;
  }
  void push_back(BumpAlloc<> &alloc, Address *a, unsigned idx) {
    if (idx) subTrees[idx - 1].exit.push_back(alloc, a);
    else header.push_back(alloc, a);
  }
  void push_front(BumpAlloc<> &alloc, Address *a, unsigned idx) {
    if (idx) subTrees[idx - 1].exit.push_front(alloc, a);
    else header.push_front(alloc, a);
  }
  // can we hoist forward out of this loop?
  // NOLINTNEXTLINE(misc-no-recursion)
  auto hoist(BumpAlloc<> &alloc, Address *a, unsigned currentLoop)
    -> Optional<unsigned> {
    if (a->wasVisited3()) {
      if (a->getLoopTreeSchedule() == this) return a->getBlockIdx();
      return {};
    }
    a->visit3();
    // it isn't allowed to depend on deeper loops
    auto *L = a->getLoopTreeSchedule();
    bool placed = L != this;
    if ((placed && (L->getParent() != this || a->dependsOnIndVars(getDepth()))))
      return {};
    // we're trying to hoist into either idxFront or idxBack
    unsigned idxFront = 2 * currentLoop, idxBack = idxFront + 2;
    bool legalHoistFront = true, legalHoistBack = true;
    for (auto *p : a->inNeighbors(getDepth())) {
      auto pIdx = getIdx(p);
      if (pIdx <= idxFront) continue;
      bool fail = pIdx >= idxBack;
      if (!fail) {
        if (auto hIdx = hoist(alloc, p, currentLoop))
          fail = *hIdx > currentLoop;
        else fail = true;
      }
      if (fail) {
        legalHoistFront = false;
        break;
      }
    }
    if (legalHoistFront) {
      if (placed) {
        invariant(L->try_delete(a));
        a->setLoopTreeSchedule(this);
      }
      a->setBlockIdx(currentLoop);
      push_back(alloc, a, currentLoop);
      a->place();
      return currentLoop;
    }
    for (auto *c : a->outNeighbors(getDepth())) {
      auto cIdx = getIdx(c);
      if (cIdx >= idxBack) continue;
      bool fail = cIdx <= idxFront;
      if (!fail) {
        if (auto hIdx = hoist(alloc, c, currentLoop))
          fail = *hIdx <= currentLoop;
        else fail = true;
      }
      if (fail) {
        legalHoistBack = false;
        break;
      }
    }
    if (legalHoistBack) {
      if (placed) {
        invariant(L->try_delete(a));
        a->setLoopTreeSchedule(this);
      }
      a->setBlockIdx(currentLoop + 1);
      invariant(currentLoop < currentLoop + 1);
      push_front(alloc, a, currentLoop + 1);
      a->place();
      return currentLoop + 1;
    }
    // FIXME: what if !placed, but hoist failed?
    // what sort of ctrl path could produce that outcome?
    invariant(placed);
    return {};
  }
  // Two possible plans:
  // 1.
  // go from a ptr to an index-based approach
  // we want the efficient set operations that `BitSet` provides
  // The plan will be to add `addr`s from previous and following loops
  // as extra edges, so that we can ensure the SCC algorithm does
  // not mix addrs from different loops.
  // 2.
  // a) every addr has an index field
  // b) we create BitSets of ancestors
  // NOLINTNEXTLINE(misc-no-recursion)
  auto placeAddr(BumpAlloc<> &alloc, LinearProgramLoopBlock &LB,
                 MutPtrVector<Address *> addr) -> unsigned {
    // we sort via repeatedly calculating the strongly connected components
    // of the address graph. The SCCs are in topological order.
    // If a load or store are isolated within a SCC from a sub-loop, we hoist
    // if it's indices do not depend on that loop.
    //
    // We will eventually insert all addr at this level and within sub-loops
    // into `addr`. We process them in batches, iterating based on `omega`
    // values. We only need to force separation here for those that are not
    // already separated.
    //
    unsigned numAddr = header.size(), numSubTrees = subTrees.size();
    addr[_(0, numAddr)] << header.getAddr();
#ifndef NDEBUG
    for (auto *a : addr[_(0, numAddr)]) invariant(!a->wasPlaced());
#endif
    header.clear();
    Vector<uint8_t> addrCounts;
    addrCounts.reserve(numSubTrees + 1);
    addrCounts.emplace_back(numAddr);
    for (auto &L : subTrees)
      addrCounts.emplace_back(
        numAddr += L.subTree->placeAddr(alloc, LB, addr[_(numAddr, end)]));

    addr = addr[_(0, numAddr)];
    numAddr_ = numAddr;
    for (unsigned i = 0; i < numAddr; ++i) {
      addr[i]->addToSubset();
      addr[i]->index() = i + numSubTrees;
    }
    for (auto *a : addr) a->calcAncestors(getDepth());
#ifndef NDEBUG
    for (auto *a : addr[_(addrCounts.front(), addrCounts.back())])
      invariant(a->wasPlaced());
#endif
    Vector<std::array<BitSet, 2>> loopRelatives{numSubTrees};
    if (numSubTrees) {
      // iterate over loops
      for (unsigned i = 0; i < subTrees.size(); ++i) {
        calcLoopNestAddrs(
          loopRelatives, addr[_(addrCounts[i], addrCounts[i + 1])], numAddr, i);
      }
    }
    // auto headerAddrs = addr[_(0, addrCounts[0])];
    llvm::SmallVector<BitSet> components;
    {
      AddressGraph g{addr, loopRelatives};
      Graphs::stronglyConnectedComponents(components, g);
    }
    size_t currentLoop = 0;
    InstructionBlock *B = &header;
    LoopTreeSchedule *L;
    bool inLoop = false;
    // two passes, first to place the addrs that don't need hoisting
    for (BitSet scc : components) {
      size_t sccsz = scc.size();
      if (sccsz == 1) {
        size_t indRaw = scc.front(), ind = indRaw - numSubTrees;
        if (ind < numAddr) {
          // four possibilities:
          // 1. inLoop && wasPlaced
          // 2. inLoop && !wasPlaced
          // 3. !inLoop && !wasPlaced
          // 4. !inLoop && wasPlaced - scc hoisted
          if (inLoop) continue;
          Address *a = addr[ind];
          invariant(!a->wasPlaced());
          // if (a->wasPlaced()) {
          //   // scc's top sort decided we can hoist
          //   invariant(a->getLoopTreeSchedule()->try_delete(a));
          //   a->setLoopTreeSchedule(this);
          // }
          a->setBlockIdx(currentLoop);
          B->push_back(alloc, a);
          a->place();
          a->visit3();
        } else {
          // invariant((ind - numAddr) & 1, size_t(inLoop));
          // invariant(currentLoop, (ind - numAddr) >> 1);
          if (inLoop) B = &subTrees[currentLoop++].exit;
          else L = subTrees[currentLoop].subTree;
          inLoop = !inLoop;
        }
      } else {
        invariant(inLoop);
#ifndef NDEBUG
        for (size_t i : scc) assert(addr[i - numSubTrees]->wasPlaced());
#endif
      }
    }
    invariant(!inLoop);
    currentLoop = 0;
    B = &header;
    for (BitSet scc : components) {
      size_t sccsz = scc.size();
      if (sccsz == 1) {
        size_t indRaw = scc.front(), ind = indRaw - numSubTrees;
        if (ind < numAddr) {
          Address *a = addr[ind];
          // four possibilities:
          // 1. inLoop && wasPlaced
          // 2. inLoop && !wasPlaced
          // 3. !inLoop && !wasPlaced
          // 4. !inLoop && wasPlaced - scc hoisted
          if (!inLoop) continue;
          // header: B
          // exit: subTrees[currentLoop].exit;
          // Here, we want a recursive approach
          // check children and check parents for hoistability
          // if all parents are hoistable in front, it can be hoisted in
          // front ditto if all children are hoistable behind we can reset
          // visited before each search
          if (!a->wasPlaced() || ((a->getLoopTreeSchedule() == L) &&
                                  !a->dependsOnIndVars(getDepth()))) {
            // hoist; do other loop members depend, or are depended on?
            invariant(hoist(alloc, a, currentLoop).hasValue() ||
                      a->wasPlaced());
          }
          a->place();
        } else {
          // invariant((ind - numAddr) & 1, size_t(inLoop));
          // invariant(currentLoop, (ind - numAddr) >> 1);
          if (inLoop) B = &subTrees[currentLoop++].exit;
          else L = subTrees[currentLoop].subTree;
          inLoop = !inLoop;
        }
      } else {
        invariant(inLoop);
#ifndef NDEBUG
        for (size_t i : scc) assert(addr[i - numSubTrees]->wasPlaced());
#endif
      }
    }
    for (auto *a : addr) a->resetBitfield();
    return numAddr;
  }
  template <typename T>
  static constexpr auto get(llvm::SmallVectorImpl<T> &x, size_t i) -> T & {
    if (i >= x.size()) x.resize(i + 1);
    return x[i];
  }
#ifndef NDEBUG
  void validate() { // NOLINT(misc-no-recursion)
    for (auto &subTree : subTrees) {
      assert(subTree.subTree->parent == this);
      assert(subTree.subTree->getDepth() == getDepth() + 1);
      subTree.subTree->validate();
    }
  }
  void validateMemPlacements() {}
#endif
public:
  [[nodiscard]] static auto init(BumpAlloc<> &alloc, LinearProgramLoopBlock &LB)
    -> LoopTreeSchedule * {
    // TODO: can we shorten the life span of the instructions we
    // allocate here to `lalloc`? I.e., do we need them to live on after
    // this forest is scheduled?

    // we first add all memory operands
    // then, we licm
    // the only kind of replication that occur are store reloads
    // size_t maxDepth = 0;
    PtrVector<ScheduledNode> lnodes = LB.getNodes();
    Vector<LoopTreeSchedule *> loops{lnodes.size()};
    LoopTreeSchedule *root{alloc.create<LoopTreeSchedule>(nullptr, 0, 0)};
    unsigned numAddr = 0;
    for (size_t i = 0; i < lnodes.size(); ++i) {
      auto &node = lnodes[i];
      LoopTreeSchedule *L = loops[i] =
        allocLoopNodes(alloc, node.getSchedule(), root);
      unsigned numMem = node.getNumMem();
      L->incNumAddr(numMem);
      numAddr += numMem;
    }
#ifndef NDEBUG
    root->validate();
#endif
    for (size_t i = 0; i < lnodes.size(); ++i)
      lnodes[i].insertMem(alloc, LB.getMem(), loops[i]);
#ifndef NDEBUG
    root->validateMemPlacements();
#endif
    // we now have a vector of addrs
    for (auto &edge : LB.getEdges()) {
      // here we add all connections to the addrs
      // edges -> MA -> Addr
      edge.input()->getAddress()->addOut(edge.output()->getAddress(),
                                         edge.satLevel());
    }
    MutPtrVector<Address *> addr{alloc.allocate<Address *>(numAddr), numAddr};
    root->placeAddr(alloc, LB, addr);
    return root;
  }
  // void initializeInstrGraph(BumpAlloc<> &alloc, Instruction::Cache &cache,
  //                           BumpAlloc<> &tAlloc, LoopTree *loopForest,
  //                           LinearProgramLoopBlock &LB,
  //                           llvm::TargetTransformInfo &TTI,
  //                           unsigned int vectorBits) {

  //   // buidInstructionGraph(alloc, cache);
  //   mergeInstructions(alloc, cache, loopForest, TTI, tAlloc, vectorBits);
  // }

  [[nodiscard]] constexpr auto getInitAddr(BumpAlloc<> &alloc)
    -> InstructionBlock & {
    if (!header.isInitialized()) header.initialize(alloc);
    return header;
  }
  [[nodiscard]] constexpr auto getDepth() const -> unsigned { return depth; }
  constexpr LoopTreeSchedule(LoopTreeSchedule *L, uint8_t d, uint8_t blockIdx)
    : subTrees{nullptr, 0, 0}, parent(L), depth(d), blckIdx(blockIdx) {}
  // NOLINTNEXTLINE(misc-no-recursion)
  void printDotEdges(llvm::raw_ostream &out,
                     llvm::ArrayRef<std::string> addrNames) {
    header.printDotEdges(out, addrNames);
    for (auto &subTree : subTrees) {
      subTree.subTree->printDotEdges(out, addrNames);
      subTree.exit.printDotEdges(out, addrNames);
    }
  }
  // NOLINTNEXTLINE(misc-no-recursion)
  auto printSubDotFile(BumpAlloc<> &alloc, llvm::raw_ostream &out,
                       map<LoopTreeSchedule *, std::string> &names,
                       llvm::SmallVectorImpl<std::string> &addrNames,
                       unsigned addrIndOffset, AffineLoopNest<false> *lret)
    -> AffineLoopNest<false> * {
    AffineLoopNest<false> *loop{nullptr};
    size_t j = 0;
    for (auto *addr : header.getAddr()) loop = addr->getLoop();
    for (auto &subTree : subTrees) {
      // `names` might realloc, relocating `names[this]`
      if (getDepth())
        names[subTree.subTree] = names[this] + "SubLoop#" + std::to_string(j++);
      else names[subTree.subTree] = "LoopNest#" + std::to_string(j++);
      if (loop == nullptr)
        for (auto *addr : subTree.exit.getAddr()) loop = addr->getLoop();
      loop = subTree.subTree->printSubDotFile(alloc, out, names, addrNames,
                                              addrIndOffset, loop);
    }
    const std::string &name = names[this];
    out << "\"" << name
        << "\" [shape=plain\nlabel = <<table><tr><td port=\"f0\">";
    // assert(depth == 0 || (loop != nullptr));
    if (loop && (getDepth() > 0)) {
      for (size_t i = loop->getNumLoops(), k = getDepth(); i > k;)
        loop = loop->removeLoop(alloc, --i);
      loop->pruneBounds(alloc);
      loop->printBounds(out);
    } else out << "Top Level";
    out << "</td></tr>\n";
    size_t i = header.printDotNodes(out, 0, addrNames, addrIndOffset, name);
    j = 0;
    std::string loopEdges;
    for (auto &subTree : subTrees) {
      std::string label = "f" + std::to_string(++i);
      out << " <tr> <td port=\"" << label << "\"> SubLoop#" << j++
          << "</td></tr>\n";
      loopEdges += "\"" + name + "\":f" + std::to_string(i) + " -> \"" +
                   names[subTree.subTree] + "\":f0 [color=\"#ff0000\"];\n";
      i = subTree.exit.printDotNodes(out, i, addrNames, addrIndOffset, name);
    }
    out << "</table>>];\n" << loopEdges;
    if (lret) return lret;
    if ((loop == nullptr) || (getDepth() <= 1)) return nullptr;
    return loop->removeLoop(alloc, getDepth() - 1);
  }

  void printDotFile(BumpAlloc<> &alloc, llvm::raw_ostream &out) {
    map<LoopTreeSchedule *, std::string> names;
    llvm::SmallVector<std::string> addrNames(numAddr_);
    names[this] = "toplevel";
    out << "digraph LoopNest {\n";
    auto p = alloc.scope();
    printSubDotFile(alloc, out, names, addrNames, subTrees.size(), nullptr);
    printDotEdges(out, addrNames);
    out << "}\n";
  }
};

static_assert(Graphs::AbstractIndexGraph<LoopTreeSchedule::AddressGraph>);
// class LoopForestSchedule : LoopTreeSchedule {
//   [[no_unique_address]] BumpAlloc<> &allocator;
// };
} // namespace CostModeling

constexpr void
ScheduledNode::insertMem(BumpAlloc<> &alloc,
                         PtrVector<MemoryAccess *> memAccess,
                         CostModeling::LoopTreeSchedule *L) const {
  // First, we invert the schedule matrix.
  SquarePtrMatrix<int64_t> Phi = schedule.getPhi();
  auto [Pinv, denom] = NormalForm::scaledInv(Phi);
  // TODO: if (s == 1) {}
  // TODO: make this function out of line
  auto &accesses{L->getInitAddr(alloc)};
  unsigned numMem = memory.size(), offset = accesses.size(),
           sId = std::numeric_limits<unsigned>::max() >> 1, j = 0;
  NotNull<AffineLoopNest<false>> loop = loopNest->rotate(alloc, Pinv, offsets);
  for (size_t i : memory) {
    NotNull<MemoryAccess> mem = memAccess[i];
    bool isStore = mem->isStore();
    if (isStore) sId = j;
    ++j;
    size_t inputEdges = mem->inputEdges().size(),
           outputEdges = mem->outputEdges().size();
    Address *addr = Address::construct(
      alloc, loop, mem, isStore, Pinv, denom, schedule.getOffsetOmega(), L,
      inputEdges, isStore ? numMem - 1 : 1, outputEdges, offsets);
    mem->setAddress(addr);
    accesses.push_back(addr);
  }
  Address *store = accesses[offset + sId];
  // addrs all need direct connections
  for (size_t i = 0, k = 0; i < numMem; ++i)
    if (i != sId) accesses[offset + i]->addDirectConnection(store, k++);
}
[[nodiscard]] constexpr auto Address::getCurrentDepth() const -> unsigned {
  return node->getDepth();
}
