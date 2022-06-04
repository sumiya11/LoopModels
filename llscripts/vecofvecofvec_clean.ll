; ModuleID = 'llscripts/vecofvecofvec.ll'
source_filename = "vecofvec"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128-ni:10:11:12:13"
target triple = "x86_64-unknown-linux-gnu"

define nonnull {}* @japi1_vecofvec_515({}* nocapture readnone %0, {}** %1, i32 %2) local_unnamed_addr #0 {
top:
  %3 = alloca {}**, align 8
  store volatile {}** %1, {}*** %3, align 8
  %4 = tail call {}*** @julia.get_pgcstack()
  %5 = load {}*, {}** %1, align 8
  %6 = bitcast {}* %5 to { i8*, i64, i16, i16, i32 }*
  %7 = getelementptr inbounds { i8*, i64, i16, i16, i32 }, { i8*, i64, i16, i16, i32 }* %6, i64 0, i32 1
  %8 = load i64, i64* %7, align 8
  %9 = tail call i64 @llvm.smax.i64(i64 %8, i64 0)
  %10 = icmp slt i64 %8, 1
  br i1 %10, label %L66, label %L14.preheader

L14.preheader:                                    ; preds = %top
  %11 = bitcast {}* %5 to {}***
  br label %L14

L14:                                              ; preds = %L14.preheader, %L54
  %value_phi3 = phi i64 [ %16, %L54 ], [ 1, %L14.preheader ]
  %12 = add nsw i64 %value_phi3, -1
  %13 = load {}**, {}*** %11, align 8
  %14 = getelementptr inbounds {}*, {}** %13, i64 %12
  %15 = load {}*, {}** %14, align 8
  %.not = icmp eq {}* %15, null
  br i1 %.not, label %fail, label %pass

L54.loopexit:                                     ; preds = %merge_own23
  br label %L54

L54:                                              ; preds = %L54.loopexit, %pass
  %.not11.not = icmp eq i64 %value_phi3, %9
  %16 = add nuw i64 %value_phi3, 1
  br i1 %.not11.not, label %L66.loopexit, label %L14

L66.loopexit:                                     ; preds = %L54
  br label %L66

L66:                                              ; preds = %L66.loopexit, %top
  ret {}* %5

fail:                                             ; preds = %L14
  tail call void @jl_throw({}* nonnull inttoptr (i64 139967618240000 to {}*))
  unreachable

pass:                                             ; preds = %L14
  %17 = bitcast {}* %15 to { i8*, i64, i16, i16, i32 }*
  %18 = getelementptr inbounds { i8*, i64, i16, i16, i32 }, { i8*, i64, i16, i16, i32 }* %17, i64 0, i32 1
  %19 = load i64, i64* %18, align 8
  %20 = tail call i64 @llvm.smax.i64(i64 %19, i64 1)
  %21 = icmp ult i64 %20, 2
  br i1 %21, label %L54, label %L30.preheader

L30.preheader:                                    ; preds = %pass
  %.not613 = icmp eq {}* %15, null
  br i1 %.not613, label %L30.preheader.fail10_crit_edge, label %pass11.lr.ph

pass11.lr.ph:                                     ; preds = %L30.preheader
  br label %pass11

L30.preheader.fail10_crit_edge:                   ; preds = %L30.preheader
  br label %fail10

L30.fail10_crit_edge:                             ; preds = %merge_own23.L30_crit_edge
  br label %fail10

fail10:                                           ; preds = %L30.fail10_crit_edge, %L30.preheader.fail10_crit_edge
  tail call void @jl_throw({}* nonnull inttoptr (i64 139967618240000 to {}*))
  unreachable

pass11:                                           ; preds = %pass11.lr.ph, %merge_own23.L30_crit_edge
  %value_phi814 = phi i64 [ 2, %pass11.lr.ph ], [ %55, %merge_own23.L30_crit_edge ]
  %22 = phi {}* [ %15, %pass11.lr.ph ], [ %.pre12, %merge_own23.L30_crit_edge ]
  %23 = add nsw i64 %value_phi814, -1
  %24 = bitcast {}* %22 to { i8*, i64, i16, i16, i32 }*
  %25 = bitcast {}* %22 to {}***
  %26 = load {}**, {}*** %25, align 8
  %27 = getelementptr inbounds {}*, {}** %26, i64 %23
  %28 = load {}*, {}** %27, align 8
  %.not7 = icmp eq {}* %28, null
  br i1 %.not7, label %fail12, label %pass15

fail12:                                           ; preds = %pass11
  tail call void @jl_throw({}* nonnull inttoptr (i64 139967618240000 to {}*))
  unreachable

pass15:                                           ; preds = %pass11
  %29 = add nsw i64 %value_phi814, -2
  %30 = getelementptr inbounds {}*, {}** %26, i64 %29
  %31 = load {}*, {}** %30, align 8
  %.not8 = icmp eq {}* %31, null
  br i1 %.not8, label %fail16, label %pass19

fail16:                                           ; preds = %pass15
  tail call void @jl_throw({}* nonnull inttoptr (i64 139967618240000 to {}*))
  unreachable

pass19:                                           ; preds = %pass15
  %32 = getelementptr inbounds { i8*, i64, i16, i16, i32 }, { i8*, i64, i16, i16, i32 }* %24, i64 0, i32 2
  %33 = load i16, i16* %32, align 2
  %34 = and i16 %33, 3
  %35 = icmp eq i16 %34, 3
  br i1 %35, label %array_owned, label %merge_own

array_owned:                                      ; preds = %pass19
  %36 = bitcast {}* %22 to {}**
  %37 = getelementptr inbounds {}*, {}** %36, i64 5
  %38 = load {}*, {}** %37, align 8
  br label %merge_own

merge_own:                                        ; preds = %array_owned, %pass19
  %39 = phi {}* [ %22, %pass19 ], [ %38, %array_owned ]
  store atomic {}* %28, {}** %30 unordered, align 8
  tail call void ({}*, ...) @julia.write_barrier({}* %39, {}* nonnull %28)
  %40 = load {}**, {}*** %11, align 8
  %41 = getelementptr inbounds {}*, {}** %40, i64 %12
  %42 = load {}*, {}** %41, align 8
  %.not9 = icmp eq {}* %42, null
  br i1 %.not9, label %fail20, label %pass21

fail20:                                           ; preds = %merge_own
  tail call void @jl_throw({}* nonnull inttoptr (i64 139967618240000 to {}*))
  unreachable

pass21:                                           ; preds = %merge_own
  %43 = bitcast {}* %42 to { i8*, i64, i16, i16, i32 }*
  %44 = getelementptr inbounds { i8*, i64, i16, i16, i32 }, { i8*, i64, i16, i16, i32 }* %43, i64 0, i32 2
  %45 = load i16, i16* %44, align 2
  %46 = and i16 %45, 3
  %47 = icmp eq i16 %46, 3
  br i1 %47, label %array_owned22, label %merge_own23

array_owned22:                                    ; preds = %pass21
  %48 = bitcast {}* %42 to {}**
  %49 = getelementptr inbounds {}*, {}** %48, i64 5
  %50 = load {}*, {}** %49, align 8
  br label %merge_own23

merge_own23:                                      ; preds = %array_owned22, %pass21
  %51 = phi {}* [ %42, %pass21 ], [ %50, %array_owned22 ]
  %52 = bitcast {}* %42 to {}***
  %53 = load {}**, {}*** %52, align 8
  %54 = getelementptr inbounds {}*, {}** %53, i64 %23
  store atomic {}* %31, {}** %54 unordered, align 8
  tail call void ({}*, ...) @julia.write_barrier({}* %51, {}* nonnull %31)
  %.not10 = icmp eq i64 %value_phi814, %20
  br i1 %.not10, label %L54.loopexit, label %merge_own23.L30_crit_edge

merge_own23.L30_crit_edge:                        ; preds = %merge_own23
  %55 = add nuw i64 %value_phi814, 1
  %.pre = load {}**, {}*** %11, align 8
  %.phi.trans.insert = getelementptr inbounds {}*, {}** %.pre, i64 %12
  %.pre12 = load {}*, {}** %.phi.trans.insert, align 8
  %.not6 = icmp eq {}* %.pre12, null
  br i1 %.not6, label %L30.fail10_crit_edge, label %pass11
}

declare {}*** @julia.get_pgcstack() local_unnamed_addr

declare void @jl_throw({}*) local_unnamed_addr

declare void @julia.write_barrier({}*, ...) local_unnamed_addr

; Function Attrs: nocallback nofree nosync nounwind readnone speculatable willreturn
declare i64 @llvm.smax.i64(i64, i64) #1

attributes #0 = { "probe-stack"="inline-asm" "thunk" }
attributes #1 = { nocallback nofree nosync nounwind readnone speculatable willreturn }

!llvm.module.flags = !{!0, !1}

!0 = !{i32 2, !"Dwarf Version", i32 4}
!1 = !{i32 2, !"Debug Info Version", i32 3}
