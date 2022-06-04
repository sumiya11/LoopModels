; ModuleID = 'llscripts/selfdot.ll'
source_filename = "selfdot"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128-ni:10:11:12:13"
target triple = "x86_64-unknown-linux-gnu"

define float @julia_selfdot_500({}* nocapture nonnull readonly align 16 dereferenceable(40) %0) local_unnamed_addr #0 {
top:
  %1 = tail call {}*** @julia.get_pgcstack()
  %2 = bitcast {}* %0 to { i8*, i64, i16, i16, i32 }*
  %3 = getelementptr inbounds { i8*, i64, i16, i16, i32 }, { i8*, i64, i16, i16, i32 }* %2, i64 0, i32 1
  %4 = load i64, i64* %3, align 8
  %5 = icmp slt i64 %4, 1
  br i1 %5, label %L43, label %L18

L18:                                              ; preds = %top
  %6 = bitcast {}* %0 to float**
  %7 = load float*, float** %6, align 16
  %8 = add nuw i64 %4, 1
  %value_phi37 = load float, float* %7, align 4
  %9 = fadd float 0.000000e+00, %value_phi37
  %exitcond.not8 = icmp eq i64 2, %8
  br i1 %exitcond.not8, label %L43.loopexit, label %L37.lr.ph

L37.lr.ph:                                        ; preds = %L18
  br label %L37

L37:                                              ; preds = %L37.lr.ph, %L37
  %10 = phi float [ %9, %L37.lr.ph ], [ %14, %L37 ]
  %value_phi49 = phi i64 [ 2, %L37.lr.ph ], [ %13, %L37 ]
  %11 = add i64 %value_phi49, -1
  %12 = getelementptr inbounds float, float* %7, i64 %11
  %13 = add i64 %value_phi49, 1
  %value_phi3 = load float, float* %12, align 4
  %14 = fadd float %10, %value_phi3
  %exitcond.not = icmp eq i64 %13, %8
  br i1 %exitcond.not, label %L20.L43.loopexit_crit_edge, label %L37

L20.L43.loopexit_crit_edge:                       ; preds = %L37
  %split = phi float [ %14, %L37 ]
  br label %L43.loopexit

L43.loopexit:                                     ; preds = %L20.L43.loopexit_crit_edge, %L18
  %.lcssa = phi float [ %split, %L20.L43.loopexit_crit_edge ], [ %9, %L18 ]
  br label %L43

L43:                                              ; preds = %L43.loopexit, %top
  %value_phi9 = phi float [ 0.000000e+00, %top ], [ %.lcssa, %L43.loopexit ]
  ret float %value_phi9
}

define nonnull {}* @jfptr_selfdot_501({}* nocapture readnone %0, {}** nocapture readonly %1, i32 %2) local_unnamed_addr #1 {
top:
  %3 = tail call {}*** @julia.get_pgcstack()
  %4 = load {}*, {}** %1, align 8
  %5 = tail call float @julia_selfdot_500({}* %4) #0
  %6 = tail call {}* @jl_box_float32(float %5)
  ret {}* %6
}

declare {}*** @julia.get_pgcstack() local_unnamed_addr

declare {}* @jl_box_float32(float) local_unnamed_addr

attributes #0 = { "probe-stack"="inline-asm" }
attributes #1 = { "probe-stack"="inline-asm" "thunk" }

!llvm.module.flags = !{!0, !1}

!0 = !{i32 2, !"Dwarf Version", i32 4}
!1 = !{i32 2, !"Debug Info Version", i32 3}
