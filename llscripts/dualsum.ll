; ModuleID = 'dualsum'
source_filename = "dualsum"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128-ni:10:11:12:13"
target triple = "x86_64-unknown-linux-gnu"

;  @ /home/sumiya11/loops/writefunc.jl:11 within `dualsum`
define [2 x float] @julia_dualsum_473([2 x float]* nocapture nonnull readonly align 4 dereferenceable(8) %0, [2 x float]* nocapture nonnull readonly align 4 dereferenceable(8) %1) #0 {
top:
  %2 = alloca [2 x float], align 4
  %3 = call {}*** @julia.get_pgcstack()
  %4 = bitcast {}*** %3 to {}**
  %current_task = getelementptr inbounds {}*, {}** %4, i64 2305843009213693940
  %5 = bitcast {}** %current_task to i64*
  %world_age = getelementptr inbounds i64, i64* %5, i64 13
;  @ /home/sumiya11/loops/writefunc.jl:12 within `dualsum`
; ┌ @ Base.jl:42 within `getproperty`
   %6 = getelementptr inbounds [2 x float], [2 x float]* %0, i32 0, i32 0
; └
; ┌ @ number.jl:42 within `iszero`
; │┌ @ float.jl:437 within `==`
    %7 = load float, float* %6, align 4
    %8 = fcmp oeq float %7, 0.000000e+00
; └└
; ┌ @ bool.jl:35 within `!`
   %9 = zext i1 %8 to i8
   %10 = xor i8 %9, 1
; └
; ┌ @ /home/sumiya11/.julia/packages/VectorizationBase/cU9ca/src/llvm_intrin/intrin_funcs.jl:35 within `assume`
   call void @julia_dualsum_473u475(i8 %10)
; └
;  @ /home/sumiya11/loops/writefunc.jl:13 within `dualsum`
; ┌ @ Base.jl:42 within `getproperty`
   %11 = getelementptr inbounds [2 x float], [2 x float]* %1, i32 0, i32 0
; └
; ┌ @ number.jl:42 within `iszero`
; │┌ @ float.jl:437 within `==`
    %12 = load float, float* %11, align 4
    %13 = fcmp oeq float %12, 0.000000e+00
; └└
; ┌ @ bool.jl:35 within `!`
   %14 = zext i1 %13 to i8
   %15 = xor i8 %14, 1
; └
; ┌ @ /home/sumiya11/.julia/packages/VectorizationBase/cU9ca/src/llvm_intrin/intrin_funcs.jl:35 within `assume`
   call void @julia_dualsum_473u476(i8 %15)
; └
;  @ /home/sumiya11/loops/writefunc.jl:15 within `dualsum`
; ┌ @ Base.jl:42 within `getproperty`
   %16 = getelementptr inbounds [2 x float], [2 x float]* %0, i32 0, i32 0
   %17 = getelementptr inbounds [2 x float], [2 x float]* %1, i32 0, i32 0
; └
; ┌ @ float.jl:398 within `+`
   %18 = load float, float* %16, align 4
   %19 = load float, float* %17, align 4
   %20 = fadd float %18, %19
; └
; ┌ @ Base.jl:42 within `getproperty`
   %21 = getelementptr inbounds [2 x float], [2 x float]* %0, i32 0, i32 1
   %22 = getelementptr inbounds [2 x float], [2 x float]* %1, i32 0, i32 1
; └
; ┌ @ float.jl:398 within `+`
   %23 = load float, float* %21, align 4
   %24 = load float, float* %22, align 4
   %25 = fadd float %23, %24
; └
; ┌ @ /home/sumiya11/loops/writefunc.jl:7 within `Dual`
   %26 = getelementptr inbounds [2 x float], [2 x float]* %2, i32 0, i32 0
   store float %20, float* %26, align 4
   %27 = getelementptr inbounds [2 x float], [2 x float]* %2, i32 0, i32 1
   store float %25, float* %27, align 4
; └
  %28 = load [2 x float], [2 x float]* %2, align 4
  ret [2 x float] %28
}

define nonnull {}* @jfptr_dualsum_474({}* %0, {}** %1, i32 %2) #1 {
top:
  %3 = alloca [2 x float], align 4
  %4 = call {}*** @julia.get_pgcstack()
  %5 = getelementptr inbounds {}*, {}** %1, i32 0
  %6 = load {}*, {}** %5, align 8
  %7 = bitcast {}* %6 to [2 x float]*
  %8 = getelementptr inbounds {}*, {}** %1, i32 1
  %9 = load {}*, {}** %8, align 8
  %10 = bitcast {}* %9 to [2 x float]*
  %11 = call [2 x float] @julia_dualsum_473([2 x float]* nocapture readonly %7, [2 x float]* nocapture readonly %10) #0
  store [2 x float] %11, [2 x float]* %3, align 4
  %12 = bitcast {}*** %4 to {}**
  %current_task = getelementptr inbounds {}*, {}** %12, i64 2305843009213693940
  %ptls_field = getelementptr inbounds {}*, {}** %current_task, i64 14
  %ptls_load = load {}*, {}** %ptls_field, align 8
  %13 = bitcast {}* %ptls_load to {}**
  %14 = bitcast {}** %13 to i8*
  %15 = call noalias nonnull {}* @julia.gc_alloc_obj(i8* %14, i64 8, {}* inttoptr (i64 139966330688448 to {}*)) #5
  %16 = bitcast {}* %15 to i8*
  %17 = bitcast [2 x float]* %3 to i8*
  call void @llvm.memcpy.p0i8.p0i8.i64(i8* align 8 %16, i8* %17, i64 8, i1 false)
  ret {}* %15
}

declare {}*** @julia.get_pgcstack()

declare {}* @julia.gc_alloc_obj(i8*, i64, {}*)

; Function Attrs: alwaysinline
define private void @julia_dualsum_473u475(i8 %0) #2 {
top:
  %b = trunc i8 %0 to i1
  call void @llvm.assume(i1 %b)
  ret void
}

; Function Attrs: nofree nosync nounwind willreturn
declare void @llvm.assume(i1 noundef) #3

; Function Attrs: alwaysinline
define private void @julia_dualsum_473u476(i8 %0) #2 {
top:
  %b = trunc i8 %0 to i1
  call void @llvm.assume(i1 %b)
  ret void
}

; Function Attrs: argmemonly nofree nosync nounwind willreturn
declare void @llvm.memcpy.p0i8.p0i8.i64(i8* noalias nocapture writeonly, i8* noalias nocapture readonly, i64, i1 immarg) #4

attributes #0 = { "probe-stack"="inline-asm" }
attributes #1 = { "probe-stack"="inline-asm" "thunk" }
attributes #2 = { alwaysinline }
attributes #3 = { nofree nosync nounwind willreturn }
attributes #4 = { argmemonly nofree nosync nounwind willreturn }
attributes #5 = { allocsize(1) }

!llvm.module.flags = !{!0, !1}

!0 = !{i32 2, !"Dwarf Version", i32 4}
!1 = !{i32 2, !"Debug Info Version", i32 3}
