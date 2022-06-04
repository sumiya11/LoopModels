; ModuleID = 'llscripts/my_sqrt2.ll'
source_filename = "my_sqrt2"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128-ni:10:11:12:13"
target triple = "x86_64-unknown-linux-gnu"

define float @julia_my_sqrt2_485(float %0) local_unnamed_addr #0 {
L10:
  %1 = tail call {}*** @julia.get_pgcstack()
  %2 = fcmp oge float %0, 0.000000e+00
  tail call void @llvm.assume(i1 %2) #4
  %3 = fcmp uge float %0, 0.000000e+00
  tail call void @llvm.assume(i1 %3) #4
  %4 = tail call float @llvm.sqrt.f32(float %0)
  ret float %4
}

define nonnull {}* @jfptr_my_sqrt2_486({}* nocapture readnone %0, {}** nocapture readonly %1, i32 %2) local_unnamed_addr #1 {
top:
  %3 = tail call {}*** @julia.get_pgcstack()
  %4 = bitcast {}** %1 to float**
  %5 = load float*, float** %4, align 8
  %6 = load float, float* %5, align 4
  %7 = tail call {}*** @julia.get_pgcstack()
  %8 = fcmp oge float %6, 0.000000e+00
  tail call void @llvm.assume(i1 %8) #4
  %9 = fcmp uge float %6, 0.000000e+00
  tail call void @llvm.assume(i1 %9) #4
  %10 = tail call float @llvm.sqrt.f32(float %6)
  %11 = tail call {}* @jl_box_float32(float %10)
  ret {}* %11
}

declare {}*** @julia.get_pgcstack() local_unnamed_addr

declare {}* @jl_box_float32(float) local_unnamed_addr

; Function Attrs: mustprogress nocallback nofree nosync nounwind readnone speculatable willreturn
declare float @llvm.sqrt.f32(float) #2

; Function Attrs: inaccessiblememonly mustprogress nocallback nofree nosync nounwind willreturn
declare void @llvm.assume(i1 noundef) #3

attributes #0 = { "probe-stack"="inline-asm" }
attributes #1 = { "probe-stack"="inline-asm" "thunk" }
attributes #2 = { mustprogress nocallback nofree nosync nounwind readnone speculatable willreturn }
attributes #3 = { inaccessiblememonly mustprogress nocallback nofree nosync nounwind willreturn }
attributes #4 = { nounwind }

!llvm.module.flags = !{!0, !1}

!0 = !{i32 2, !"Dwarf Version", i32 4}
!1 = !{i32 2, !"Debug Info Version", i32 3}
