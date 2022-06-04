; ModuleID = 'my_sum'
source_filename = "my_sum"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128-ni:10:11:12:13"
target triple = "x86_64-unknown-linux-gnu"

;  @ /home/sumiya11/loops/writefunc.jl:22 within `my_sum`
define i64 @julia_my_sum_463(i64 signext %0, i64 signext %1) #0 {
top:
  %2 = call {}*** @julia.get_pgcstack()
  %3 = bitcast {}*** %2 to {}**
  %current_task = getelementptr inbounds {}*, {}** %3, i64 2305843009213693940
  %4 = bitcast {}** %current_task to i64*
  %world_age = getelementptr inbounds i64, i64* %4, i64 13
;  @ /home/sumiya11/loops/writefunc.jl:23 within `my_sum`
; ┌ @ operators.jl:378 within `>`
; │┌ @ int.jl:83 within `<`
    %5 = icmp slt i64 0, %1
; └└
; ┌ @ /home/sumiya11/.julia/packages/VectorizationBase/cU9ca/src/llvm_intrin/intrin_funcs.jl:35 within `assume`
   %6 = zext i1 %5 to i8
   call void @julia_my_sum_463u465(i8 %6)
; └
;  @ /home/sumiya11/loops/writefunc.jl:24 within `my_sum`
; ┌ @ int.jl:87 within `+`
   %7 = add i64 %0, %1
; └
;  @ /home/sumiya11/loops/writefunc.jl:25 within `my_sum`
; ┌ @ int.jl:86 within `-`
   %8 = sub i64 %1, %7
; └
  ret i64 %8
}

define nonnull {}* @jfptr_my_sum_464({}* %0, {}** %1, i32 %2) #1 {
top:
  %3 = call {}*** @julia.get_pgcstack()
  %4 = getelementptr inbounds {}*, {}** %1, i32 0
  %5 = load {}*, {}** %4, align 8
  %6 = bitcast {}* %5 to i64*
  %7 = load i64, i64* %6, align 8
  %8 = getelementptr inbounds {}*, {}** %1, i32 1
  %9 = load {}*, {}** %8, align 8
  %10 = bitcast {}* %9 to i64*
  %11 = load i64, i64* %10, align 8
  %12 = call i64 @julia_my_sum_463(i64 signext %7, i64 signext %11) #0
  %13 = call nonnull {}* @jl_box_int64(i64 signext %12)
  ret {}* %13
}

declare {}*** @julia.get_pgcstack()

declare {}* @jl_box_int64(i64)

; Function Attrs: alwaysinline
define private void @julia_my_sum_463u465(i8 %0) #2 {
top:
  %b = trunc i8 %0 to i1
  call void @llvm.assume(i1 %b)
  ret void
}

; Function Attrs: nofree nosync nounwind willreturn
declare void @llvm.assume(i1 noundef) #3

attributes #0 = { "probe-stack"="inline-asm" }
attributes #1 = { "probe-stack"="inline-asm" "thunk" }
attributes #2 = { alwaysinline }
attributes #3 = { nofree nosync nounwind willreturn }

!llvm.module.flags = !{!0, !1}

!0 = !{i32 2, !"Dwarf Version", i32 4}
!1 = !{i32 2, !"Debug Info Version", i32 3}
