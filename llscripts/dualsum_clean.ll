; ModuleID = 'llscripts/dualsum.ll'
source_filename = "dualsum"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128-ni:10:11:12:13"
target triple = "x86_64-unknown-linux-gnu"

define [2 x float] @julia_dualsum_473([2 x float]* nocapture nonnull readonly align 4 dereferenceable(8) %0, [2 x float]* nocapture nonnull readonly align 4 dereferenceable(8) %1) local_unnamed_addr #0 {
top:
  %2 = tail call {}*** @julia.get_pgcstack()
  %3 = getelementptr inbounds [2 x float], [2 x float]* %0, i64 0, i64 0
  %4 = load float, float* %3, align 4
  %5 = fcmp une float %4, 0.000000e+00
  tail call void @llvm.assume(i1 %5) #3
  %6 = getelementptr inbounds [2 x float], [2 x float]* %1, i64 0, i64 0
  %7 = load float, float* %6, align 4
  %8 = fcmp une float %7, 0.000000e+00
  tail call void @llvm.assume(i1 %8) #3
  %9 = fadd float %4, %7
  %10 = getelementptr inbounds [2 x float], [2 x float]* %0, i64 0, i64 1
  %11 = getelementptr inbounds [2 x float], [2 x float]* %1, i64 0, i64 1
  %12 = load float, float* %10, align 4
  %13 = load float, float* %11, align 4
  %14 = fadd float %12, %13
  %.fca.0.insert = insertvalue [2 x float] poison, float %9, 0
  %.fca.1.insert = insertvalue [2 x float] %.fca.0.insert, float %14, 1
  ret [2 x float] %.fca.1.insert
}

define noalias nonnull {}* @jfptr_dualsum_474({}* nocapture readnone %0, {}** nocapture readonly %1, i32 %2) local_unnamed_addr #1 {
top:
  %3 = tail call {}*** @julia.get_pgcstack()
  %4 = bitcast {}** %1 to [2 x float]**
  %5 = load [2 x float]*, [2 x float]** %4, align 8
  %6 = getelementptr inbounds {}*, {}** %1, i64 1
  %7 = bitcast {}** %6 to [2 x float]**
  %8 = load [2 x float]*, [2 x float]** %7, align 8
  %9 = tail call [2 x float] @julia_dualsum_473([2 x float]* nocapture readonly %5, [2 x float]* nocapture readonly %8) #0
  %.fca.0.extract = extractvalue [2 x float] %9, 0
  %.fca.1.extract = extractvalue [2 x float] %9, 1
  %ptls_field2 = getelementptr inbounds {}**, {}*** %3, i64 2305843009213693954
  %10 = bitcast {}*** %ptls_field2 to i8**
  %ptls_load34 = load i8*, i8** %10, align 8
  %11 = tail call noalias nonnull {}* @julia.gc_alloc_obj(i8* %ptls_load34, i64 8, {}* nonnull inttoptr (i64 139966330688448 to {}*)) #4
  %12 = bitcast {}* %11 to i8*
  %.sroa.0.0..sroa_cast = bitcast {}* %11 to float*
  store float %.fca.0.extract, float* %.sroa.0.0..sroa_cast, align 8
  %.sroa.2.0..sroa_idx = getelementptr inbounds i8, i8* %12, i64 4
  %.sroa.2.0..sroa_cast = bitcast i8* %.sroa.2.0..sroa_idx to float*
  store float %.fca.1.extract, float* %.sroa.2.0..sroa_cast, align 4
  ret {}* %11
}

declare {}*** @julia.get_pgcstack() local_unnamed_addr

declare {}* @julia.gc_alloc_obj(i8*, i64, {}*) local_unnamed_addr

; Function Attrs: inaccessiblememonly mustprogress nocallback nofree nosync nounwind willreturn
declare void @llvm.assume(i1 noundef) #2

attributes #0 = { "probe-stack"="inline-asm" }
attributes #1 = { "probe-stack"="inline-asm" "thunk" }
attributes #2 = { inaccessiblememonly mustprogress nocallback nofree nosync nounwind willreturn }
attributes #3 = { nounwind }
attributes #4 = { allocsize(1) }

!llvm.module.flags = !{!0, !1}

!0 = !{i32 2, !"Dwarf Version", i32 4}
!1 = !{i32 2, !"Debug Info Version", i32 3}
