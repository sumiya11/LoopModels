; ModuleID = 'my_sqrt1'
source_filename = "my_sqrt1"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128-ni:10:11:12:13"
target triple = "x86_64-unknown-linux-gnu"

;  @ /home/sumiya11/loops/writefunc.jl:36 within `my_sqrt1`
define float @julia_my_sqrt1_482(float %0) #0 {
top:
  %1 = call {}*** @julia.get_pgcstack()
  %2 = bitcast {}*** %1 to {}**
  %current_task = getelementptr inbounds {}*, {}** %2, i64 2305843009213693940
  %3 = bitcast {}** %current_task to i64*
  %world_age = getelementptr inbounds i64, i64* %3, i64 13
;  @ /home/sumiya11/loops/writefunc.jl:37 within `my_sqrt1`
; ┌ @ math.jl:567 within `sqrt`
; │┌ @ float.jl:443 within `<`
    %4 = fcmp olt float %0, 0.000000e+00
; │└
   %5 = zext i1 %4 to i8
   %6 = trunc i8 %5 to i1
   %7 = xor i1 %6, true
   br i1 %7, label %L5, label %L3

L3:                                               ; preds = %top
   %8 = call nonnull {}* @j_throw_complex_domainerror_484({}* inttoptr (i64 139967792990784 to {}*), float %0) #0
   call void @llvm.trap()
   unreachable

L5:                                               ; preds = %top
; └
; ┌ @ math.jl:568 within `sqrt`
   %9 = call float @llvm.sqrt.f32(float %0)
   br label %L7

L7:                                               ; preds = %L5
; └
  ret float %9

after_noret:                                      ; No predecessors!
; ┌ @ math.jl:567 within `sqrt`
   unreachable
; └
}

define nonnull {}* @jfptr_my_sqrt1_483({}* %0, {}** %1, i32 %2) #1 {
top:
  %3 = call {}*** @julia.get_pgcstack()
  %4 = getelementptr inbounds {}*, {}** %1, i32 0
  %5 = load {}*, {}** %4, align 8
  %6 = bitcast {}* %5 to float*
  %7 = load float, float* %6, align 4
  %8 = call float @julia_my_sqrt1_482(float %7) #0
  %9 = call {}* @jl_box_float32(float %8)
  ret {}* %9
}

declare {}*** @julia.get_pgcstack()

declare {}* @jl_box_float32(float)

declare {}* @j_throw_complex_domainerror_484({}*, float)

; Function Attrs: cold noreturn nounwind
declare void @llvm.trap() #2

; Function Attrs: nofree nosync nounwind readnone speculatable willreturn
declare float @llvm.sqrt.f32(float) #3

attributes #0 = { "probe-stack"="inline-asm" }
attributes #1 = { "probe-stack"="inline-asm" "thunk" }
attributes #2 = { cold noreturn nounwind }
attributes #3 = { nofree nosync nounwind readnone speculatable willreturn }

!llvm.module.flags = !{!0, !1}

!0 = !{i32 2, !"Dwarf Version", i32 4}
!1 = !{i32 2, !"Debug Info Version", i32 3}
