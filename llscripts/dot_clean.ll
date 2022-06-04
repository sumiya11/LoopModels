; ModuleID = 'llscripts/dot.ll'
source_filename = "my_dot"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128-ni:10:11:12:13"
target triple = "x86_64-unknown-linux-gnu"

define i64 @julia_my_dot_469({}* nocapture nonnull readonly align 16 dereferenceable(40) %0, {}* nocapture nonnull readonly align 16 dereferenceable(40) %1) local_unnamed_addr #0 {
top:
  %2 = tail call {}*** @julia.get_pgcstack()
  %3 = bitcast {}* %0 to { i8*, i64, i16, i16, i32 }*
  %4 = getelementptr inbounds { i8*, i64, i16, i16, i32 }, { i8*, i64, i16, i16, i32 }* %3, i64 0, i32 1
  %5 = load i64, i64* %4, align 8
  %6 = tail call i64 @llvm.smax.i64(i64 %5, i64 0)
  %7 = icmp slt i64 %5, 1
  br i1 %7, label %L33, label %L14.preheader

L14.preheader:                                    ; preds = %top
  %8 = bitcast {}* %0 to i64**
  %9 = load i64*, i64** %8, align 16
  %10 = bitcast {}* %1 to i64**
  %11 = load i64*, i64** %10, align 16
  br label %L14

L14:                                              ; preds = %L14.preheader, %L14
  %value_phi3 = phi i64 [ %19, %L14 ], [ 1, %L14.preheader ]
  %value_phi5 = phi i64 [ %18, %L14 ], [ 0, %L14.preheader ]
  %12 = add nsw i64 %value_phi3, -1
  %13 = getelementptr inbounds i64, i64* %9, i64 %12
  %14 = load i64, i64* %13, align 8
  %15 = getelementptr inbounds i64, i64* %11, i64 %12
  %16 = load i64, i64* %15, align 8
  %17 = mul i64 %16, %14
  %18 = add i64 %17, %value_phi5
  %.not.not = icmp eq i64 %value_phi3, %6
  %19 = add nuw i64 %value_phi3, 1
  br i1 %.not.not, label %L33.loopexit, label %L14

L33.loopexit:                                     ; preds = %L14
  %.lcssa = phi i64 [ %18, %L14 ]
  br label %L33

L33:                                              ; preds = %L33.loopexit, %top
  %value_phi9 = phi i64 [ 0, %top ], [ %.lcssa, %L33.loopexit ]
  ret i64 %value_phi9
}

define nonnull {}* @jfptr_my_dot_470({}* nocapture readnone %0, {}** nocapture readonly %1, i32 %2) local_unnamed_addr #1 {
top:
  %3 = tail call {}*** @julia.get_pgcstack()
  %4 = load {}*, {}** %1, align 8
  %5 = getelementptr inbounds {}*, {}** %1, i64 1
  %6 = load {}*, {}** %5, align 8
  %7 = tail call i64 @julia_my_dot_469({}* %4, {}* %6) #0
  %8 = tail call nonnull {}* @jl_box_int64(i64 signext %7)
  ret {}* %8
}

declare {}*** @julia.get_pgcstack() local_unnamed_addr

declare {}* @jl_box_int64(i64) local_unnamed_addr

; Function Attrs: nocallback nofree nosync nounwind readnone speculatable willreturn
declare i64 @llvm.smax.i64(i64, i64) #2

attributes #0 = { "probe-stack"="inline-asm" }
attributes #1 = { "probe-stack"="inline-asm" "thunk" }
attributes #2 = { nocallback nofree nosync nounwind readnone speculatable willreturn }

!llvm.module.flags = !{!0, !1}

!0 = !{i32 2, !"Dwarf Version", i32 4}
!1 = !{i32 2, !"Debug Info Version", i32 3}
