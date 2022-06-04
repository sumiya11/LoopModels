; ModuleID = 'my_id'
source_filename = "my_id"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128-ni:10:11:12:13"
target triple = "x86_64-unknown-linux-gnu"

define i64 @julia_my_id_116(i64 signext %0) #0 !dbg !5 {
top:
  %1 = call {}*** @julia.get_pgcstack()
  %2 = bitcast {}*** %1 to {}**
  %current_task = getelementptr inbounds {}*, {}** %2, i64 2305843009213693940
  %3 = bitcast {}** %current_task to i64*
  %world_age = getelementptr inbounds i64, i64* %3, i64 13
  ret i64 %0, !dbg !7
}

define nonnull {} addrspace(10)* @jfptr_my_id_117({} addrspace(10)* %0, {} addrspace(10)** %1, i32 %2) #1 {
top:
  %3 = call {}*** @julia.get_pgcstack()
  %4 = getelementptr inbounds {} addrspace(10)*, {} addrspace(10)** %1, i32 0
  %5 = load {} addrspace(10)*, {} addrspace(10)** %4, align 8, !nonnull !4, !dereferenceable !8, !align !8
  %6 = bitcast {} addrspace(10)* %5 to i64 addrspace(10)*
  %7 = addrspacecast i64 addrspace(10)* %6 to i64 addrspace(11)*
  %8 = load i64, i64 addrspace(11)* %7, align 8
  %9 = call i64 @julia_my_id_116(i64 signext %8) #0
  %10 = getelementptr inbounds {} addrspace(10)*, {} addrspace(10)** %1, i32 0
  %11 = load {} addrspace(10)*, {} addrspace(10)** %10, align 8
  ret {} addrspace(10)* %11
}

declare {}*** @julia.get_pgcstack()

attributes #0 = { "probe-stack"="inline-asm" }
attributes #1 = { "probe-stack"="inline-asm" "thunk" }

!llvm.module.flags = !{!0, !1}
!llvm.dbg.cu = !{!2}

!0 = !{i32 2, !"Dwarf Version", i32 4}
!1 = !{i32 2, !"Debug Info Version", i32 3}
!2 = distinct !DICompileUnit(language: DW_LANG_Julia, file: !3, producer: "julia", isOptimized: true, runtimeVersion: 0, emissionKind: FullDebug, enums: !4, nameTableKind: GNU)
!3 = !DIFile(filename: "/home/sumiya11/loops/writefunc.jl", directory: ".")
!4 = !{}
!5 = distinct !DISubprogram(name: "my_id", linkageName: "julia_my_id_116", scope: null, file: !3, line: 2, type: !6, scopeLine: 2, spFlags: DISPFlagDefinition | DISPFlagOptimized, unit: !2, retainedNodes: !4)
!6 = !DISubroutineType(types: !4)
!7 = !DILocation(line: 3, scope: !5)
!8 = !{i64 8}
