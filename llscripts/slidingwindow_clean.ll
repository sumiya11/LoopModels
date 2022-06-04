; ModuleID = 'llscripts/slidingwindow.ll'
source_filename = "slidingwindow"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128-ni:10:11:12:13"
target triple = "x86_64-unknown-linux-gnu"

define i32 @julia_slidingwindow_508({}* nonnull align 16 dereferenceable(40) %0, i64 signext %1) local_unnamed_addr #0 {
top:
  %2 = tail call {}*** @julia.get_pgcstack()
  %3 = bitcast {}* %0 to { i8*, i64, i16, i16, i32 }*
  %4 = getelementptr inbounds { i8*, i64, i16, i16, i32 }, { i8*, i64, i16, i16, i32 }* %3, i64 0, i32 1
  %5 = load i64, i64* %4, align 8
  %6 = icmp ne i64 %5, 0
  tail call void @llvm.assume(i1 %6) #4
  %7 = bitcast {}* %0 to i32**
  %8 = load i32*, i32** %7, align 16
  %9 = load i32, i32* %8, align 4
  %10 = sub i64 %5, %1
  %11 = tail call i64 @llvm.smax.i64(i64 %10, i64 0)
  %12 = icmp slt i64 %10, 1
  br i1 %12, label %L69, label %L21.preheader

L21.preheader:                                    ; preds = %top
  br label %L21

L21:                                              ; preds = %L21.preheader, %L56
  %value_phi3 = phi i64 [ %21, %L56 ], [ 1, %L21.preheader ]
  %value_phi5 = phi i32 [ %value_phi15, %L56 ], [ %9, %L21.preheader ]
  %13 = add i64 %value_phi3, %1
  %.not5 = icmp sgt i64 %value_phi3, %13
  %14 = add nsw i64 %value_phi3, -1
  %15 = select i1 %.not5, i64 %14, i64 %13
  br i1 %.not5, label %L56, label %L38.preheader

L38.preheader:                                    ; preds = %L21
  br label %L38

L38:                                              ; preds = %L38.preheader, %L38
  %value_phi9 = phi i32 [ %19, %L38 ], [ %value_phi5, %L38.preheader ]
  %value_phi10 = phi i64 [ %20, %L38 ], [ %value_phi3, %L38.preheader ]
  %16 = add i64 %value_phi10, -1
  %17 = getelementptr inbounds i32, i32* %8, i64 %16
  %18 = load i32, i32* %17, align 4
  %19 = tail call i32 @llvm.smax.i32(i32 %18, i32 %value_phi9)
  %.not8.not = icmp eq i64 %value_phi10, %15
  %20 = add i64 %value_phi10, 1
  br i1 %.not8.not, label %L56.loopexit, label %L38

L56.loopexit:                                     ; preds = %L38
  %.lcssa = phi i32 [ %19, %L38 ]
  br label %L56

L56:                                              ; preds = %L56.loopexit, %L21
  %value_phi15 = phi i32 [ %value_phi5, %L21 ], [ %.lcssa, %L56.loopexit ]
  %.not9.not = icmp eq i64 %value_phi3, %11
  %21 = add nuw i64 %value_phi3, 1
  br i1 %.not9.not, label %L69.loopexit, label %L21

L69.loopexit:                                     ; preds = %L56
  %value_phi15.lcssa = phi i32 [ %value_phi15, %L56 ]
  br label %L69

L69:                                              ; preds = %L69.loopexit, %top
  %value_phi19 = phi i32 [ %9, %top ], [ %value_phi15.lcssa, %L69.loopexit ]
  ret i32 %value_phi19
}

define nonnull {}* @jfptr_slidingwindow_509({}* nocapture readnone %0, {}** nocapture readonly %1, i32 %2) local_unnamed_addr #1 {
top:
  %3 = tail call {}*** @julia.get_pgcstack()
  %4 = load {}*, {}** %1, align 8
  %5 = getelementptr inbounds {}*, {}** %1, i64 1
  %6 = bitcast {}** %5 to i64**
  %7 = load i64*, i64** %6, align 8
  %8 = load i64, i64* %7, align 8
  %9 = tail call i32 @julia_slidingwindow_508({}* %4, i64 signext %8) #0
  %10 = tail call nonnull {}* @jl_box_int32(i32 signext %9)
  ret {}* %10
}

declare {}*** @julia.get_pgcstack() local_unnamed_addr

declare {}* @jl_box_int32(i32) local_unnamed_addr

; Function Attrs: inaccessiblememonly mustprogress nocallback nofree nosync nounwind willreturn
declare void @llvm.assume(i1 noundef) #2

; Function Attrs: nocallback nofree nosync nounwind readnone speculatable willreturn
declare i64 @llvm.smax.i64(i64, i64) #3

; Function Attrs: nocallback nofree nosync nounwind readnone speculatable willreturn
declare i32 @llvm.smax.i32(i32, i32) #3

attributes #0 = { "probe-stack"="inline-asm" }
attributes #1 = { "probe-stack"="inline-asm" "thunk" }
attributes #2 = { inaccessiblememonly mustprogress nocallback nofree nosync nounwind willreturn }
attributes #3 = { nocallback nofree nosync nounwind readnone speculatable willreturn }
attributes #4 = { nounwind }

!llvm.module.flags = !{!0, !1}

!0 = !{i32 2, !"Dwarf Version", i32 4}
!1 = !{i32 2, !"Debug Info Version", i32 3}
