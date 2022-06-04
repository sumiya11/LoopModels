; ModuleID = 'llscripts/my_loop_1.ll'
source_filename = "my_loop_1"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128-ni:10:11:12:13"
target triple = "x86_64-unknown-linux-gnu"

@jl_boxed_int8_cache = external local_unnamed_addr constant [256 x {}*]

define i8 @julia_my_loop_1_494({}* nocapture nonnull readonly align 16 dereferenceable(40) %0) local_unnamed_addr #0 {
top:
  %1 = tail call {}*** @julia.get_pgcstack()
  %2 = bitcast {}* %0 to { i8*, i64, i16, i16, i32 }*
  %3 = getelementptr inbounds { i8*, i64, i16, i16, i32 }, { i8*, i64, i16, i16, i32 }* %2, i64 0, i32 1
  %4 = load i64, i64* %3, align 8
  %5 = tail call i64 @llvm.smax.i64(i64 %4, i64 0)
  %6 = icmp slt i64 %4, 1
  br i1 %6, label %L31, label %L14.preheader

L14.preheader:                                    ; preds = %top
  %7 = bitcast {}* %0 to i8**
  %8 = load i8*, i8** %7, align 16
  br label %L14

L14:                                              ; preds = %L14.preheader, %L14
  %value_phi3 = phi i64 [ %13, %L14 ], [ 1, %L14.preheader ]
  %value_phi5 = phi i8 [ %12, %L14 ], [ 0, %L14.preheader ]
  %9 = add nsw i64 %value_phi3, -1
  %10 = getelementptr inbounds i8, i8* %8, i64 %9
  %11 = load i8, i8* %10, align 1
  %12 = add i8 %11, %value_phi5
  %.not.not = icmp eq i64 %value_phi3, %5
  %13 = add nuw i64 %value_phi3, 1
  br i1 %.not.not, label %L31.loopexit, label %L14

L31.loopexit:                                     ; preds = %L14
  %.lcssa = phi i8 [ %12, %L14 ]
  br label %L31

L31:                                              ; preds = %L31.loopexit, %top
  %value_phi9 = phi i8 [ 0, %top ], [ %.lcssa, %L31.loopexit ]
  ret i8 %value_phi9
}

define nonnull {}* @jfptr_my_loop_1_495({}* nocapture readnone %0, {}** nocapture readonly %1, i32 %2) local_unnamed_addr #1 {
top:
  %3 = tail call {}*** @julia.get_pgcstack()
  %4 = load {}*, {}** %1, align 8
  %5 = tail call i8 @julia_my_loop_1_494({}* %4) #0
  %6 = zext i8 %5 to i64
  %7 = getelementptr inbounds [256 x {}*], [256 x {}*]* @jl_boxed_int8_cache, i64 0, i64 %6
  %8 = load {}*, {}** %7, align 8
  ret {}* %8
}

declare {}*** @julia.get_pgcstack() local_unnamed_addr

; Function Attrs: nocallback nofree nosync nounwind readnone speculatable willreturn
declare i64 @llvm.smax.i64(i64, i64) #2

attributes #0 = { "probe-stack"="inline-asm" }
attributes #1 = { "probe-stack"="inline-asm" "thunk" }
attributes #2 = { nocallback nofree nosync nounwind readnone speculatable willreturn }

!llvm.module.flags = !{!0, !1}

!0 = !{i32 2, !"Dwarf Version", i32 4}
!1 = !{i32 2, !"Debug Info Version", i32 3}
