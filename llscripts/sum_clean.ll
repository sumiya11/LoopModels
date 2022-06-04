; ModuleID = 'llscripts/sum.ll'
source_filename = "my_sum"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128-ni:10:11:12:13"
target triple = "x86_64-unknown-linux-gnu"

define i64 @julia_my_sum_463(i64 signext %0, i64 signext %1) local_unnamed_addr #0 {
top:
  %2 = tail call {}*** @julia.get_pgcstack()
  %3 = icmp sgt i64 %1, 0
  tail call void @llvm.assume(i1 %3) #3
  %4 = sub i64 0, %0
  ret i64 %4
}

define nonnull {}* @jfptr_my_sum_464({}* nocapture readnone %0, {}** nocapture readonly %1, i32 %2) local_unnamed_addr #1 {
top:
  %3 = tail call {}*** @julia.get_pgcstack()
  %4 = bitcast {}** %1 to i64**
  %5 = load i64*, i64** %4, align 8
  %6 = load i64, i64* %5, align 8
  %7 = getelementptr inbounds {}*, {}** %1, i64 1
  %8 = bitcast {}** %7 to i64**
  %9 = load i64*, i64** %8, align 8
  %10 = load i64, i64* %9, align 8
  %11 = tail call {}*** @julia.get_pgcstack()
  %12 = icmp sgt i64 %10, 0
  tail call void @llvm.assume(i1 %12) #3
  %13 = sub i64 0, %6
  %14 = tail call nonnull {}* @jl_box_int64(i64 signext %13)
  ret {}* %14
}

declare {}*** @julia.get_pgcstack() local_unnamed_addr

declare {}* @jl_box_int64(i64) local_unnamed_addr

; Function Attrs: inaccessiblememonly mustprogress nocallback nofree nosync nounwind willreturn
declare void @llvm.assume(i1 noundef) #2

attributes #0 = { "probe-stack"="inline-asm" }
attributes #1 = { "probe-stack"="inline-asm" "thunk" }
attributes #2 = { inaccessiblememonly mustprogress nocallback nofree nosync nounwind willreturn }
attributes #3 = { nounwind }

!llvm.module.flags = !{!0, !1}

!0 = !{i32 2, !"Dwarf Version", i32 4}
!1 = !{i32 2, !"Debug Info Version", i32 3}
