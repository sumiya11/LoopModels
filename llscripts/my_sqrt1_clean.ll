; ModuleID = 'llscripts/my_sqrt1.ll'
source_filename = "my_sqrt1"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128-ni:10:11:12:13"
target triple = "x86_64-unknown-linux-gnu"

define float @julia_my_sqrt1_482(float %0) local_unnamed_addr #0 {
top:
  %1 = tail call {}*** @julia.get_pgcstack()
  %2 = fcmp uge float %0, 0.000000e+00
  br i1 %2, label %L5, label %L3

L3:                                               ; preds = %top
  %3 = tail call nonnull {}* @j_throw_complex_domainerror_484({}* nonnull inttoptr (i64 139967792990784 to {}*), float %0) #0
  tail call void @llvm.trap()
  unreachable

L5:                                               ; preds = %top
  %4 = tail call float @llvm.sqrt.f32(float %0)
  ret float %4
}

define nonnull {}* @jfptr_my_sqrt1_483({}* nocapture readnone %0, {}** nocapture readonly %1, i32 %2) local_unnamed_addr #1 {
top:
  %3 = tail call {}*** @julia.get_pgcstack()
  %4 = bitcast {}** %1 to float**
  %5 = load float*, float** %4, align 8
  %6 = load float, float* %5, align 4
  %7 = tail call float @julia_my_sqrt1_482(float %6) #0
  %8 = tail call {}* @jl_box_float32(float %7)
  ret {}* %8
}

declare {}*** @julia.get_pgcstack() local_unnamed_addr

declare {}* @jl_box_float32(float) local_unnamed_addr

declare {}* @j_throw_complex_domainerror_484({}*, float) local_unnamed_addr

; Function Attrs: cold noreturn nounwind
declare void @llvm.trap() #2

; Function Attrs: mustprogress nocallback nofree nosync nounwind readnone speculatable willreturn
declare float @llvm.sqrt.f32(float) #3

attributes #0 = { "probe-stack"="inline-asm" }
attributes #1 = { "probe-stack"="inline-asm" "thunk" }
attributes #2 = { cold noreturn nounwind }
attributes #3 = { mustprogress nocallback nofree nosync nounwind readnone speculatable willreturn }

!llvm.module.flags = !{!0, !1}

!0 = !{i32 2, !"Dwarf Version", i32 4}
!1 = !{i32 2, !"Debug Info Version", i32 3}
