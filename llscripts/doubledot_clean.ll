; ModuleID = 'llscripts/doubledot.ll'
source_filename = "doubledot"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128-ni:10:11:12:13"
target triple = "x86_64-unknown-linux-gnu"

define i32 @julia_doubledot_504({}* nocapture nonnull readonly align 16 dereferenceable(40) %0, {}* nocapture nonnull readonly align 16 dereferenceable(40) %1, {}* nocapture nonnull readonly align 16 dereferenceable(40) %2) local_unnamed_addr #0 {
top:
  %3 = tail call {}*** @julia.get_pgcstack()
  %4 = bitcast {}* %0 to {}**
  %5 = getelementptr inbounds {}*, {}** %4, i64 3
  %6 = bitcast {}** %5 to i64*
  %7 = load i64, i64* %6, align 8
  %8 = tail call i64 @llvm.smax.i64(i64 %7, i64 0)
  %9 = bitcast {}* %1 to {}**
  %10 = getelementptr inbounds {}*, {}** %9, i64 3
  %11 = bitcast {}** %10 to i64*
  %12 = load i64, i64* %11, align 8
  %13 = tail call i64 @llvm.smax.i64(i64 %12, i64 0)
  %14 = icmp sgt i64 %7, 0
  br i1 %14, label %L11, label %L9

L9:                                               ; preds = %top
  %15 = icmp slt i64 %12, 1
  br i1 %15, label %L64.thread, label %L24

L64.thread:                                       ; preds = %L9
  %16 = bitcast {}* %2 to {}**
  %17 = getelementptr inbounds {}*, {}** %16, i64 3
  %18 = bitcast {}** %17 to i64*
  %19 = load i64, i64* %18, align 8
  %20 = tail call i64 @llvm.smax.i64(i64 %19, i64 0)
  br label %L73

L11:                                              ; preds = %top
  %.not28 = icmp eq i64 %8, 1
  br i1 %.not28, label %L13, label %L19

L13:                                              ; preds = %L11
  %21 = icmp eq i64 %13, 1
  br i1 %21, label %L35, label %L24

L19:                                              ; preds = %L11
  %22 = icmp eq i64 %8, %13
  br i1 %22, label %L35, label %L24

L24:                                              ; preds = %L13, %L9, %L19
  %ptls_field2723 = getelementptr inbounds {}**, {}*** %3, i64 2305843009213693954
  %23 = bitcast {}*** %ptls_field2723 to i8**
  %ptls_load282425 = load i8*, i8** %23, align 8
  %24 = tail call noalias nonnull {}* @julia.gc_alloc_obj(i8* %ptls_load282425, i64 8, {}* nonnull inttoptr (i64 139967573382544 to {}*)) #4
  %25 = bitcast {}* %24 to i64*
  store i64 %8, i64* %25, align 8
  %ptls_load312627 = load i8*, i8** %23, align 8
  %26 = tail call noalias nonnull {}* @julia.gc_alloc_obj(i8* %ptls_load312627, i64 8, {}* nonnull inttoptr (i64 139967573382544 to {}*)) #4
  %27 = bitcast {}* %26 to i64*
  store i64 %13, i64* %27, align 8
  %28 = tail call cc38 nonnull {}* bitcast ({}* ({}*, {}**, i32, {}*)* @jl_invoke to {}* ({}*, {}*, {}*, {}*, {}*)*)({}* nonnull inttoptr (i64 139967594503632 to {}*), {}* nonnull inttoptr (i64 139967594505392 to {}*), {}* nonnull inttoptr (i64 139967574198336 to {}*), {}* nonnull %24, {}* nonnull %26)
  tail call void @llvm.trap()
  unreachable

L35:                                              ; preds = %L13, %L19
  %29 = bitcast {}* %0 to i32**
  %30 = load i32*, i32** %29, align 16
  %31 = bitcast {}* %1 to i32**
  %32 = load i32*, i32** %31, align 16
  br label %L45

L45:                                              ; preds = %L35, %L45
  %value_phi4 = phi i64 [ 1, %L35 ], [ %40, %L45 ]
  %value_phi6 = phi i32 [ 0, %L35 ], [ %39, %L45 ]
  %33 = add i64 %value_phi4, -1
  %34 = getelementptr inbounds i32, i32* %30, i64 %33
  %35 = load i32, i32* %34, align 4
  %36 = getelementptr inbounds i32, i32* %32, i64 %33
  %37 = load i32, i32* %36, align 4
  %38 = mul i32 %37, %35
  %39 = add i32 %38, %value_phi6
  %.not.not = icmp eq i64 %value_phi4, %8
  %40 = add i64 %value_phi4, 1
  br i1 %.not.not, label %L64, label %L45

L64:                                              ; preds = %L45
  %.lcssa42 = phi i32 [ %39, %L45 ]
  %41 = bitcast {}* %2 to {}**
  %42 = getelementptr inbounds {}*, {}** %41, i64 3
  %43 = bitcast {}** %42 to i64*
  %44 = load i64, i64* %43, align 8
  %45 = tail call i64 @llvm.smax.i64(i64 %44, i64 0)
  %46 = icmp sgt i64 %12, 0
  br i1 %46, label %L75, label %L73

L73:                                              ; preds = %L64.thread, %L64
  %47 = phi i64 [ %20, %L64.thread ], [ %45, %L64 ]
  %48 = phi i64 [ %19, %L64.thread ], [ %44, %L64 ]
  %value_phi1031 = phi i32 [ 0, %L64.thread ], [ %.lcssa42, %L64 ]
  %49 = icmp slt i64 %48, 1
  br i1 %49, label %L128, label %L88

L75:                                              ; preds = %L64
  %.not = icmp eq i64 %13, 1
  br i1 %.not, label %L77, label %L83

L77:                                              ; preds = %L75
  %50 = icmp eq i64 %45, 1
  br i1 %50, label %L109.preheader, label %L88

L83:                                              ; preds = %L75
  %51 = icmp eq i64 %13, %45
  br i1 %51, label %L109.preheader, label %L88

L88:                                              ; preds = %L77, %L73, %L83
  %52 = phi i64 [ %47, %L73 ], [ %45, %L83 ], [ %45, %L77 ]
  %ptls_field18 = getelementptr inbounds {}**, {}*** %3, i64 2305843009213693954
  %53 = bitcast {}*** %ptls_field18 to i8**
  %ptls_load1920 = load i8*, i8** %53, align 8
  %54 = tail call noalias nonnull {}* @julia.gc_alloc_obj(i8* %ptls_load1920, i64 8, {}* nonnull inttoptr (i64 139967573382544 to {}*)) #4
  %55 = bitcast {}* %54 to i64*
  store i64 %13, i64* %55, align 8
  %ptls_load252122 = load i8*, i8** %53, align 8
  %56 = tail call noalias nonnull {}* @julia.gc_alloc_obj(i8* %ptls_load252122, i64 8, {}* nonnull inttoptr (i64 139967573382544 to {}*)) #4
  %57 = bitcast {}* %56 to i64*
  store i64 %52, i64* %57, align 8
  %58 = tail call cc38 nonnull {}* bitcast ({}* ({}*, {}**, i32, {}*)* @jl_invoke to {}* ({}*, {}*, {}*, {}*, {}*)*)({}* nonnull inttoptr (i64 139967594503632 to {}*), {}* nonnull inttoptr (i64 139967594505392 to {}*), {}* nonnull inttoptr (i64 139967574198336 to {}*), {}* nonnull %54, {}* nonnull %56)
  tail call void @llvm.trap()
  unreachable

L109.preheader:                                   ; preds = %L83, %L77
  %59 = load i32*, i32** %31, align 16
  %60 = bitcast {}* %2 to i32**
  %61 = load i32*, i32** %60, align 16
  br label %L109

L109:                                             ; preds = %L109.preheader, %L109
  %value_phi15 = phi i64 [ %69, %L109 ], [ 1, %L109.preheader ]
  %value_phi17 = phi i32 [ %68, %L109 ], [ 0, %L109.preheader ]
  %62 = add i64 %value_phi15, -1
  %63 = getelementptr inbounds i32, i32* %59, i64 %62
  %64 = load i32, i32* %63, align 4
  %65 = getelementptr inbounds i32, i32* %61, i64 %62
  %66 = load i32, i32* %65, align 4
  %67 = mul i32 %66, %64
  %68 = add i32 %67, %value_phi17
  %.not.not17 = icmp eq i64 %value_phi15, %13
  %69 = add i64 %value_phi15, 1
  br i1 %.not.not17, label %L128.loopexit, label %L109

L128.loopexit:                                    ; preds = %L109
  %.lcssa = phi i32 [ %68, %L109 ]
  br label %L128

L128:                                             ; preds = %L128.loopexit, %L73
  %value_phi10303236 = phi i32 [ %value_phi1031, %L73 ], [ %.lcssa42, %L128.loopexit ]
  %value_phi21 = phi i32 [ 0, %L73 ], [ %.lcssa, %L128.loopexit ]
  %70 = add i32 %value_phi21, %value_phi10303236
  ret i32 %70
}

define nonnull {}* @jfptr_doubledot_505({}* nocapture readnone %0, {}** nocapture readonly %1, i32 %2) local_unnamed_addr #1 {
top:
  %3 = tail call {}*** @julia.get_pgcstack()
  %4 = load {}*, {}** %1, align 8
  %5 = getelementptr inbounds {}*, {}** %1, i64 1
  %6 = load {}*, {}** %5, align 8
  %7 = getelementptr inbounds {}*, {}** %1, i64 2
  %8 = load {}*, {}** %7, align 8
  %9 = tail call i32 @julia_doubledot_504({}* %4, {}* %6, {}* %8) #0
  %10 = tail call nonnull {}* @jl_box_int32(i32 signext %9)
  ret {}* %10
}

declare {}*** @julia.get_pgcstack() local_unnamed_addr

declare {}* @jl_box_int32(i32) local_unnamed_addr

declare {}* @jl_invoke({}*, {}**, i32, {}*) local_unnamed_addr

declare {}* @julia.gc_alloc_obj(i8*, i64, {}*) local_unnamed_addr

; Function Attrs: cold noreturn nounwind
declare void @llvm.trap() #2

; Function Attrs: nocallback nofree nosync nounwind readnone speculatable willreturn
declare i64 @llvm.smax.i64(i64, i64) #3

attributes #0 = { "probe-stack"="inline-asm" }
attributes #1 = { "probe-stack"="inline-asm" "thunk" }
attributes #2 = { cold noreturn nounwind }
attributes #3 = { nocallback nofree nosync nounwind readnone speculatable willreturn }
attributes #4 = { allocsize(1) }

!llvm.module.flags = !{!0, !1}

!0 = !{i32 2, !"Dwarf Version", i32 4}
!1 = !{i32 2, !"Debug Info Version", i32 3}
