; ModuleID = 'dotprod.ll'
source_filename = "#14"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128-ni:10:11:12:13"
target triple = "x86_64-w64-windows-gnu-elf"

; Function Attrs: uwtable
define double @"julia_#14_3016"({} addrspace(10)* nocapture nonnull readonly align 16 dereferenceable(40) %0, {} addrspace(10)* nocapture nonnull readonly align 16 dereferenceable(40) %1) local_unnamed_addr #0 !dbg !5 {
top:
  %2 = tail call {}*** @julia.get_pgcstack()
  %3 = bitcast {} addrspace(10)* %0 to {} addrspace(10)* addrspace(10)*, !dbg !7
  %4 = addrspacecast {} addrspace(10)* addrspace(10)* %3 to {} addrspace(10)* addrspace(11)*, !dbg !7
  %5 = getelementptr inbounds {} addrspace(10)*, {} addrspace(10)* addrspace(11)* %4, i64 3, !dbg !7
  %6 = bitcast {} addrspace(10)* addrspace(11)* %5 to i64 addrspace(11)*, !dbg !7
  %7 = load i64, i64 addrspace(11)* %6, align 8, !dbg !7, !tbaa !20, !range !25
  %8 = bitcast {} addrspace(10)* %1 to {} addrspace(10)* addrspace(10)*, !dbg !26
  %9 = addrspacecast {} addrspace(10)* addrspace(10)* %8 to {} addrspace(10)* addrspace(11)*, !dbg !26
  %10 = getelementptr inbounds {} addrspace(10)*, {} addrspace(10)* addrspace(11)* %9, i64 3, !dbg !26
  %11 = bitcast {} addrspace(10)* addrspace(11)* %10 to i64 addrspace(11)*, !dbg !26
  %12 = load i64, i64 addrspace(11)* %11, align 8, !dbg !26, !tbaa !20, !range !25
  switch i64 %7, label %L19 [
    i64 0, label %L9
    i64 1, label %L13
  ], !dbg !35

L9:                                               ; preds = %top
  %13 = icmp eq i64 %12, 0, !dbg !38
  br i1 %13, label %L64, label %L24, !dbg !34

L13:                                              ; preds = %top
  %14 = icmp eq i64 %12, 1, !dbg !46
  br i1 %14, label %L35, label %L24, !dbg !34

L19:                                              ; preds = %top
  %15 = icmp eq i64 %7, %12, !dbg !52
  br i1 %15, label %L35, label %L24, !dbg !34

L24:                                              ; preds = %L13, %L9, %L19
  %ptls_field9 = getelementptr inbounds {}**, {}*** %2, i64 2305843009213693954, !dbg !34
  %16 = bitcast {}*** %ptls_field9 to i8**, !dbg !34
  %ptls_load1011 = load i8*, i8** %16, align 8, !dbg !34, !tbaa !54
  %17 = tail call noalias nonnull {} addrspace(10)* @julia.gc_alloc_obj(i8* %ptls_load1011, i64 8, {} addrspace(10)* addrspacecast ({}* inttoptr (i64 284657952 to {}*) to {} addrspace(10)*)) #2, !dbg !34
  %18 = bitcast {} addrspace(10)* %17 to i64 addrspace(10)*, !dbg !34
  store i64 %7, i64 addrspace(10)* %18, align 8, !dbg !34, !tbaa !56
  %ptls_load141213 = load i8*, i8** %16, align 8, !dbg !34, !tbaa !54
  %19 = tail call noalias nonnull {} addrspace(10)* @julia.gc_alloc_obj(i8* %ptls_load141213, i64 8, {} addrspace(10)* addrspacecast ({}* inttoptr (i64 284657952 to {}*) to {} addrspace(10)*)) #2, !dbg !34
  %20 = bitcast {} addrspace(10)* %19 to i64 addrspace(10)*, !dbg !34
  store i64 %12, i64 addrspace(10)* %20, align 8, !dbg !34, !tbaa !56
  %21 = tail call cc38 nonnull {} addrspace(10)* bitcast ({} addrspace(10)* ({} addrspace(10)*, {} addrspace(10)**, i32, {} addrspace(10)*)* @jl_invoke to {} addrspace(10)* ({} addrspace(10)*, {} addrspace(10)*, {} addrspace(10)*, {} addrspace(10)*, {} addrspace(10)*)*)({} addrspace(10)* addrspacecast ({}* inttoptr (i64 308189568 to {}*) to {} addrspace(10)*), {} addrspace(10)* addrspacecast ({}* inttoptr (i64 308191328 to {}*) to {} addrspace(10)*), {} addrspace(10)* addrspacecast ({}* inttoptr (i64 287929728 to {}*) to {} addrspace(10)*), {} addrspace(10)* nonnull %17, {} addrspace(10)* nonnull %19), !dbg !34
  tail call void @llvm.trap(), !dbg !34
  unreachable, !dbg !34

L35:                                              ; preds = %L13, %L19
  %22 = bitcast {} addrspace(10)* %0 to double addrspace(13)* addrspace(10)*
  %23 = addrspacecast double addrspace(13)* addrspace(10)* %22 to double addrspace(13)* addrspace(11)*
  %24 = load double addrspace(13)*, double addrspace(13)* addrspace(11)* %23, align 8, !tbaa !60, !nonnull !4
  %25 = bitcast {} addrspace(10)* %1 to double addrspace(13)* addrspace(10)*
  %26 = addrspacecast double addrspace(13)* addrspace(10)* %25 to double addrspace(13)* addrspace(11)*
  %27 = load double addrspace(13)*, double addrspace(13)* addrspace(11)* %26, align 8, !tbaa !60, !nonnull !4
  br label %L45, !dbg !19

L45:                                              ; preds = %L35, %L45
  %value_phi4 = phi i64 [ 1, %L35 ], [ %35, %L45 ]
  %value_phi6 = phi double [ 0.000000e+00, %L35 ], [ %34, %L45 ]
  %28 = add i64 %value_phi4, -1, !dbg !62
  %29 = getelementptr inbounds double, double addrspace(13)* %24, i64 %28, !dbg !62
  %30 = load double, double addrspace(13)* %29, align 8, !dbg !62, !tbaa !65
  %31 = getelementptr inbounds double, double addrspace(13)* %27, i64 %28, !dbg !62
  %32 = load double, double addrspace(13)* %31, align 8, !dbg !62, !tbaa !65
  %33 = fmul fast double %32, %30, !dbg !67
  %34 = fadd fast double %33, %value_phi6, !dbg !70
  %.not8.not = icmp eq i64 %value_phi4, %7, !dbg !72
  %35 = add i64 %value_phi4, 1, !dbg !73
  br i1 %.not8.not, label %L64.loopexit, label %L45, !dbg !64

L64.loopexit:                                     ; preds = %L45
  %.lcssa = phi double [ %34, %L45 ], !dbg !70
  br label %L64, !dbg !75

L64:                                              ; preds = %L64.loopexit, %L9
  %value_phi10 = phi double [ 0.000000e+00, %L9 ], [ %.lcssa, %L64.loopexit ]
  ret double %value_phi10, !dbg !75
}

; Function Attrs: uwtable
define noalias nonnull {} addrspace(10)* @"jfptr_#14_3017"({} addrspace(10)* nocapture readnone %0, {} addrspace(10)** nocapture readonly %1, i32 %2) local_unnamed_addr #1 {
top:
  %3 = tail call {}*** @julia.get_pgcstack()
  %4 = load {} addrspace(10)*, {} addrspace(10)** %1, align 8, !nonnull !4, !dereferenceable !76, !align !77
  %5 = getelementptr inbounds {} addrspace(10)*, {} addrspace(10)** %1, i64 1
  %6 = load {} addrspace(10)*, {} addrspace(10)** %5, align 8, !nonnull !4, !dereferenceable !76, !align !77
  %7 = tail call double @"julia_#14_3016"({} addrspace(10)* %4, {} addrspace(10)* %6) #0
  %ptls_field2 = getelementptr inbounds {}**, {}*** %3, i64 2305843009213693954
  %8 = bitcast {}*** %ptls_field2 to i8**
  %ptls_load34 = load i8*, i8** %8, align 8, !tbaa !54
  %9 = tail call noalias nonnull {} addrspace(10)* @julia.gc_alloc_obj(i8* %ptls_load34, i64 8, {} addrspace(10)* addrspacecast ({}* inttoptr (i64 284448992 to {}*) to {} addrspace(10)*)) #2
  %10 = bitcast {} addrspace(10)* %9 to double addrspace(10)*
  store double %7, double addrspace(10)* %10, align 8, !tbaa !56
  ret {} addrspace(10)* %9
}

declare {}*** @julia.get_pgcstack() local_unnamed_addr

; Function Attrs: allocsize(1)
declare noalias nonnull {} addrspace(10)* @julia.gc_alloc_obj(i8*, i64, {} addrspace(10)*) local_unnamed_addr #2

declare nonnull {} addrspace(10)* @jl_invoke({} addrspace(10)*, {} addrspace(10)** nocapture readonly, i32, {} addrspace(10)*) local_unnamed_addr

; Function Attrs: cold noreturn nounwind
declare void @llvm.trap() #3

attributes #0 = { uwtable "frame-pointer"="all" }
attributes #1 = { uwtable "frame-pointer"="all" "thunk" }
attributes #2 = { allocsize(1) }
attributes #3 = { cold noreturn nounwind }

!llvm.module.flags = !{!0, !1}
!llvm.dbg.cu = !{!2}

!0 = !{i32 2, !"Dwarf Version", i32 4}
!1 = !{i32 2, !"Debug Info Version", i32 3}
!2 = distinct !DICompileUnit(language: DW_LANG_Julia, file: !3, producer: "julia", isOptimized: true, runtimeVersion: 0, emissionKind: FullDebug, enums: !4, nameTableKind: GNU)
!3 = !DIFile(filename: "C:\\data\\projects\\loops\\LoopModels\\julia\\writefunc.jl", directory: ".")
!4 = !{}
!5 = distinct !DISubprogram(name: "#14", linkageName: "julia_#14_3016", scope: null, file: !3, line: 14, type: !6, scopeLine: 14, spFlags: DISPFlagDefinition | DISPFlagOptimized, unit: !2, retainedNodes: !4)
!6 = !DISubroutineType(types: !4)
!7 = !DILocation(line: 151, scope: !8, inlinedAt: !10)
!8 = distinct !DISubprogram(name: "size;", linkageName: "size", scope: !9, file: !9, type: !6, spFlags: DISPFlagDefinition | DISPFlagOptimized, unit: !2, retainedNodes: !4)
!9 = !DIFile(filename: "array.jl", directory: ".")
!10 = !DILocation(line: 95, scope: !11, inlinedAt: !13)
!11 = distinct !DISubprogram(name: "axes;", linkageName: "axes", scope: !12, file: !12, type: !6, spFlags: DISPFlagDefinition | DISPFlagOptimized, unit: !2, retainedNodes: !4)
!12 = !DIFile(filename: "abstractarray.jl", directory: ".")
!13 = !DILocation(line: 116, scope: !14, inlinedAt: !15)
!14 = distinct !DISubprogram(name: "axes1;", linkageName: "axes1", scope: !12, file: !12, type: !6, spFlags: DISPFlagDefinition | DISPFlagOptimized, unit: !2, retainedNodes: !4)
!15 = !DILocation(line: 335, scope: !16, inlinedAt: !17)
!16 = distinct !DISubprogram(name: "eachindex;", linkageName: "eachindex", scope: !12, file: !12, type: !6, spFlags: DISPFlagDefinition | DISPFlagOptimized, unit: !2, retainedNodes: !4)
!17 = !DILocation(line: 338, scope: !16, inlinedAt: !18)
!18 = !DILocation(line: 328, scope: !16, inlinedAt: !19)
!19 = !DILocation(line: 15, scope: !5)
!20 = !{!21, !21, i64 0}
!21 = !{!"jtbaa_arraysize", !22, i64 0}
!22 = !{!"jtbaa_array", !23, i64 0}
!23 = !{!"jtbaa", !24, i64 0}
!24 = !{!"jtbaa"}
!25 = !{i64 0, i64 9223372036854775807}
!26 = !DILocation(line: 151, scope: !8, inlinedAt: !27)
!27 = !DILocation(line: 95, scope: !11, inlinedAt: !28)
!28 = !DILocation(line: 116, scope: !14, inlinedAt: !29)
!29 = !DILocation(line: 335, scope: !16, inlinedAt: !30)
!30 = !DILocation(line: 339, scope: !31, inlinedAt: !32)
!31 = distinct !DISubprogram(name: "#121;", linkageName: "#121", scope: !12, file: !12, type: !6, spFlags: DISPFlagDefinition | DISPFlagOptimized, unit: !2, retainedNodes: !4)
!32 = !DILocation(line: 345, scope: !33, inlinedAt: !34)
!33 = distinct !DISubprogram(name: "_all_match_first;", linkageName: "_all_match_first", scope: !12, file: !12, type: !6, spFlags: DISPFlagDefinition | DISPFlagOptimized, unit: !2, retainedNodes: !4)
!34 = !DILocation(line: 339, scope: !16, inlinedAt: !18)
!35 = !DILocation(line: 1043, scope: !36, inlinedAt: !32)
!36 = distinct !DISubprogram(name: "==;", linkageName: "==", scope: !37, file: !37, type: !6, spFlags: DISPFlagDefinition | DISPFlagOptimized, unit: !2, retainedNodes: !4)
!37 = !DIFile(filename: "range.jl", directory: ".")
!38 = !DILocation(line: 83, scope: !39, inlinedAt: !41)
!39 = distinct !DISubprogram(name: "<;", linkageName: "<", scope: !40, file: !40, type: !6, spFlags: DISPFlagDefinition | DISPFlagOptimized, unit: !2, retainedNodes: !4)
!40 = !DIFile(filename: "int.jl", directory: ".")
!41 = !DILocation(line: 378, scope: !42, inlinedAt: !44)
!42 = distinct !DISubprogram(name: ">;", linkageName: ">", scope: !43, file: !43, type: !6, spFlags: DISPFlagDefinition | DISPFlagOptimized, unit: !2, retainedNodes: !4)
!43 = !DIFile(filename: "operators.jl", directory: ".")
!44 = !DILocation(line: 609, scope: !45, inlinedAt: !35)
!45 = distinct !DISubprogram(name: "isempty;", linkageName: "isempty", scope: !37, file: !37, type: !6, spFlags: DISPFlagDefinition | DISPFlagOptimized, unit: !2, retainedNodes: !4)
!46 = !DILocation(line: 468, scope: !47, inlinedAt: !49)
!47 = distinct !DISubprogram(name: "==;", linkageName: "==", scope: !48, file: !48, type: !6, spFlags: DISPFlagDefinition | DISPFlagOptimized, unit: !2, retainedNodes: !4)
!48 = !DIFile(filename: "promotion.jl", directory: ".")
!49 = !DILocation(line: 1057, scope: !50, inlinedAt: !51)
!50 = distinct !DISubprogram(name: "_has_length_one;", linkageName: "_has_length_one", scope: !37, file: !37, type: !6, spFlags: DISPFlagDefinition | DISPFlagOptimized, unit: !2, retainedNodes: !4)
!51 = !DILocation(line: 1044, scope: !36, inlinedAt: !32)
!52 = !DILocation(line: 468, scope: !47, inlinedAt: !53)
!53 = !DILocation(line: 1045, scope: !36, inlinedAt: !32)
!54 = !{!55, !55, i64 0}
!55 = !{!"jtbaa_gcframe", !23, i64 0}
!56 = !{!57, !57, i64 0}
!57 = !{!"jtbaa_immut", !58, i64 0}
!58 = !{!"jtbaa_value", !59, i64 0}
!59 = !{!"jtbaa_data", !23, i64 0}
!60 = !{!61, !61, i64 0}
!61 = !{!"jtbaa_arrayptr", !22, i64 0}
!62 = !DILocation(line: 861, scope: !63, inlinedAt: !64)
!63 = distinct !DISubprogram(name: "getindex;", linkageName: "getindex", scope: !9, file: !9, type: !6, spFlags: DISPFlagDefinition | DISPFlagOptimized, unit: !2, retainedNodes: !4)
!64 = !DILocation(line: 16, scope: !5)
!65 = !{!66, !66, i64 0}
!66 = !{!"jtbaa_arraybuf", !59, i64 0}
!67 = !DILocation(line: 167, scope: !68, inlinedAt: !64)
!68 = distinct !DISubprogram(name: "mul_fast;", linkageName: "mul_fast", scope: !69, file: !69, type: !6, spFlags: DISPFlagDefinition | DISPFlagOptimized, unit: !2, retainedNodes: !4)
!69 = !DIFile(filename: "fastmath.jl", directory: ".")
!70 = !DILocation(line: 165, scope: !71, inlinedAt: !64)
!71 = distinct !DISubprogram(name: "add_fast;", linkageName: "add_fast", scope: !69, file: !69, type: !6, spFlags: DISPFlagDefinition | DISPFlagOptimized, unit: !2, retainedNodes: !4)
!72 = !DILocation(line: 468, scope: !47, inlinedAt: !73)
!73 = !DILocation(line: 837, scope: !74, inlinedAt: !64)
!74 = distinct !DISubprogram(name: "iterate;", linkageName: "iterate", scope: !37, file: !37, type: !6, spFlags: DISPFlagDefinition | DISPFlagOptimized, unit: !2, retainedNodes: !4)
!75 = !DILocation(line: 18, scope: !5)
!76 = !{i64 40}
!77 = !{i64 16}
