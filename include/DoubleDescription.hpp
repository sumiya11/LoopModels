#pragma once
#include "./Math.hpp"
#include "./POSet.hpp"
#include "./Symbolics.hpp"
#include <algorithm>
#include <llvm/ADT/SmallVector.h>

namespace Polyhedra {

// a'i == b
struct HyperPlane {
    llvm::SmallVector<intptr_t> a;
    MPoly b;
};
struct HyperPlanesIntersection {
    llvm::SmallVector<HyperPlane> hyperPlanes;
    size_t d;
    bool orthogonalized;
    auto begin() { return hyperPlanes.begin(); }
    auto end() { return hyperPlanes.end(); }
    auto begin() const { return hyperPlanes.begin(); }
    auto end() const { return hyperPlanes.end(); }
    void intersect(IntVector auto a, MPoly b) {
	if (orthogonalized){
	    assert(false);
	    // TODO: implement me!
	} else {
	    hyperPlanes.emplace_back(std::move(a), std::move(b));
	}
    }
    void intersectUnique(IntVector auto a, MPoly b) {
	for (auto &hp : *this){
	    if ((hp.a == a) && (hp.b == b)){
		return;
	    }
	}
	intersect(std::move(a), std::move(b));
    }
    void intersect(HyperPlane &h){ intersect(h.a, h.b); }
    void intersectUnique(HyperPlane &h){ intersectUnique(h.a, h.b); }
    size_t dim() const { return d; }
    size_t numHyperplanes() const { return hyperPlanes.size(); }
};

// a'i <= b
template <IntVector V> struct HalfSpace {
    V a;
    MPoly b;
};

// A'*i <= b
struct HRepresentation {
    Matrix<Int, 0, 0> A;
    llvm::SmallVector<MPoly, 8> b;

    size_t dim() const { return A.size(1); }
    size_t numEquations() const { return A.size(0); }
    llvm::SmallVector<HyperPlane> hyperplanes() const {
        return llvm::SmallVector<HyperPlane>();
    }

    auto affineHull() const {
        return HyperPlanesIntersection{hyperplanes(), dim(), false};
    }
};

bool detectOppositeElement(
    HyperPlanesIntersection &aff,
    llvm::SmallVector<HalfSpace<llvm::SmallVector<intptr_t>>> &nonOpposite,
    llvm::ArrayRef<intptr_t> a, MPoly &b) {
    
    if (isZero(b) && allZero(a)){
        return false;
    }
    for (auto &el : nonOpposite) {
        if (el.a == a && el.b == b) {
            return false;
        }
    }
    for (auto it = nonOpposite.begin(); it != nonOpposite.end(); ++it) {
        // this checks if we have any opposites, i.e. a <= b && -a <= -b -> b <=
        // a -> a == b which would mean that we have just a single hyperplane as
        // `a == b`. Not typical for a loop.
        bool match = true;
        for (size_t i = 0; i < a.size(); ++i) {
            if (a[i] != -it->a[i]) {
                match = false;
                break;
            }
        }
        if (match) {
            size_t nTerms = b.terms.size();
            auto &itbt = (it->b).terms;
            if (nTerms == itbt.size()) {
                for (size_t i = 0; i < nTerms; ++i) {
                    if (b.terms[i].coefficient != -itbt[i].coefficient) {
                        match = false;
                        break;
                    } else if (b.terms[i].exponent != itbt[i].exponent) {
                        match = false;
                        break;
                    }
                }
            }
        }
        if (match) {
            nonOpposite.erase(it);
            aff.intersect(llvm::SmallVector<intptr_t>(a.begin(),a.end()), b);
        }
    }
    return false;
}
    auto detectLinearity(HyperPlanesIntersection L){
	if (L.numHyperplanes()){
	    HyperPlanesIntersection H;
	    for (auto &h : L){
		auto hp = H.remProj(h);
		if (H.contains(h)){
		    
		}
	    }
	    return H;
	} else {
	    return L;
	}
    }
    
auto detectLinearity(HRepresentation &rep) {
    HyperPlanesIntersection aff(rep.affineHull());
    llvm::SmallVector<HalfSpace<llvm::SmallVector<intptr_t>>> els;
    for (size_t i = 0; i < rep.dim(); ++i) {
        bool newlin = false;
        for (size_t j = 0; j < rep.numEquations(); ++j) {
            newlin |=
                detectOppositeElement(aff, els, rep.A.getCol(j), rep.b[j]);
        }
	if (newlin == false){
	    break;
	}
    }
    return std::make_pair(detectLinearity(std::move(aff)), els);
    // _detect_opposite_elements(aff, els, rep);
}

} // namespace Polyhedra
