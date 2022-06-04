; ModuleID = 'selfdot'
source_filename = "selfdot"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128-ni:10:11:12:13"
target triple = "x86_64-unknown-linux-gnu"

;  @ /home/sumiya11/loops/writefunc.jl:64 within `selfdot`
define float @julia_selfdot_500({}* nonnull align 16 dereferenceable(40) %0) #0 {
top:
  %xs = alloca {}*, align 8
  %1 = call {}*** @julia.get_pgcstack()
  store {}* null, {}** %xs, align 8
  %2 = bitcast {}*** %1 to {}**
  %current_task = getelementptr inbounds {}*, {}** %2, i64 2305843009213693940
  %3 = bitcast {}** %current_task to i64*
  %world_age = getelementptr inbounds i64, i64* %3, i64 13
  store {}* %0, {}** %xs, align 8
;  @ /home/sumiya11/loops/writefunc.jl:66 within `selfdot`
; ┌ @ array.jl:835 within `iterate` @ array.jl:835
; │┌ @ array.jl:215 within `length`
    %4 = load {}*, {}** %xs, align 8
    %5 = bitcast {}* %4 to { i8*, i64, i16, i16, i32 }*
    %6 = getelementptr inbounds { i8*, i64, i16, i16, i32 }, { i8*, i64, i16, i16, i32 }* %5, i32 0, i32 1
    %7 = load i64, i64* %6, align 8
; │└
; │┌ @ int.jl:483 within `<`
; ││┌ @ operators.jl:425 within `>=`
; │││┌ @ int.jl:477 within `<=`
      %8 = icmp sle i64 0, %7
; ││└└
; ││ @ int.jl:483 within `<` @ int.jl:476
    %9 = icmp ult i64 0, %7
; ││ @ int.jl:483 within `<`
; ││┌ @ bool.jl:38 within `&`
     %10 = zext i1 %8 to i8
     %11 = zext i1 %9 to i8
     %12 = and i8 %10, %11
     %13 = trunc i8 %12 to i1
; │└└
   %14 = zext i1 %13 to i8
   %15 = trunc i8 %14 to i1
   %16 = xor i1 %15, true
   br i1 %16, label %L12, label %L9

L9:                                               ; preds = %top
; │┌ @ array.jl:861 within `getindex`
    %17 = load {}*, {}** %xs, align 8
    %18 = bitcast {}* %17 to { i8*, i64, i16, i16, i32 }*
    %19 = getelementptr inbounds { i8*, i64, i16, i16, i32 }, { i8*, i64, i16, i16, i32 }* %18, i32 0, i32 0
    %20 = load i8*, i8** %19, align 8
    %21 = bitcast i8* %20 to float*
    %22 = getelementptr inbounds float, float* %21, i64 0
    %23 = load float, float* %22, align 4
; │└
   br label %L14

L12:                                              ; preds = %top
   br label %L14

L14:                                              ; preds = %L12, %L9
   %value_phi = phi i8 [ 0, %L9 ], [ 1, %L12 ]
   %value_phi1 = phi float [ %23, %L9 ], [ undef, %L12 ]
   %value_phi2 = phi i64 [ 2, %L9 ], [ undef, %L12 ]
; │ @ array.jl:835 within `iterate`
   br label %L18

L18:                                              ; preds = %L14
; └
  %24 = xor i8 %value_phi, 1
  %25 = trunc i8 %24 to i1
  %26 = xor i1 %25, true
  br i1 %26, label %L18.L43_crit_edge, label %L18.L20_crit_edge

L18.L43_crit_edge:                                ; preds = %L18
;  @ /home/sumiya11/loops/writefunc.jl:67 within `selfdot`
; ┌ @ array.jl:835 within `iterate`
   br label %L43

L18.L20_crit_edge:                                ; preds = %L18
; └
;  @ /home/sumiya11/loops/writefunc.jl:66 within `selfdot`
; ┌ @ array.jl:835 within `iterate` @ array.jl:835
   br label %L20

L20:                                              ; preds = %L42, %L18.L20_crit_edge
   %value_phi3 = phi float [ %value_phi1, %L18.L20_crit_edge ], [ %value_phi6, %L42 ]
   %value_phi4 = phi i64 [ %value_phi2, %L18.L20_crit_edge ], [ %value_phi7, %L42 ]
   %value_phi5 = phi float [ 0.000000e+00, %L18.L20_crit_edge ], [ %27, %L42 ]
; └
;  @ /home/sumiya11/loops/writefunc.jl:67 within `selfdot`
; ┌ @ float.jl:398 within `+`
   %27 = fadd float %value_phi5, %value_phi3
; └
; ┌ @ array.jl:835 within `iterate`
; │┌ @ int.jl:982 within `-` @ int.jl:86
    %28 = sub i64 %value_phi4, 1
; │└
; │┌ @ array.jl:215 within `length`
    %29 = load {}*, {}** %xs, align 8
    %30 = bitcast {}* %29 to { i8*, i64, i16, i16, i32 }*
    %31 = getelementptr inbounds { i8*, i64, i16, i16, i32 }, { i8*, i64, i16, i16, i32 }* %30, i32 0, i32 1
    %32 = load i64, i64* %31, align 8
; │└
; │┌ @ int.jl:483 within `<`
; ││┌ @ operators.jl:425 within `>=`
; │││┌ @ int.jl:477 within `<=`
      %33 = icmp sle i64 0, %32
; ││└└
; ││ @ int.jl:483 within `<` @ int.jl:476
    %34 = icmp ult i64 %28, %32
; ││ @ int.jl:483 within `<`
; ││┌ @ bool.jl:38 within `&`
     %35 = zext i1 %33 to i8
     %36 = zext i1 %34 to i8
     %37 = and i8 %35, %36
     %38 = trunc i8 %37 to i1
; │└└
   %39 = zext i1 %38 to i8
   %40 = trunc i8 %39 to i1
   %41 = xor i1 %40, true
   br i1 %41, label %L35, label %L32

L32:                                              ; preds = %L20
; │┌ @ array.jl:861 within `getindex`
    %42 = load {}*, {}** %xs, align 8
    %43 = sub i64 %value_phi4, 1
    %44 = mul i64 %43, 1
    %45 = add i64 0, %44
    %46 = bitcast {}* %42 to { i8*, i64, i16, i16, i32 }*
    %47 = getelementptr inbounds { i8*, i64, i16, i16, i32 }, { i8*, i64, i16, i16, i32 }* %46, i32 0, i32 0
    %48 = load i8*, i8** %47, align 8
    %49 = bitcast i8* %48 to float*
    %50 = getelementptr inbounds float, float* %49, i64 %45
    %51 = load float, float* %50, align 4
; │└
; │┌ @ int.jl:87 within `+`
    %52 = add i64 %value_phi4, 1
; │└
   br label %L37

L35:                                              ; preds = %L20
   br label %L37

L37:                                              ; preds = %L35, %L32
   %value_phi6 = phi float [ %51, %L32 ], [ undef, %L35 ]
   %value_phi7 = phi i64 [ %52, %L32 ], [ undef, %L35 ]
   %value_phi8 = phi i8 [ 0, %L32 ], [ 1, %L35 ]
; └
  %53 = xor i8 %value_phi8, 1
  %54 = trunc i8 %53 to i1
  %55 = xor i1 %54, true
  br i1 %55, label %L37.L43_crit_edge, label %L42

L37.L43_crit_edge:                                ; preds = %L37
; ┌ @ array.jl:835 within `iterate`
   br label %L43

L42:                                              ; preds = %L37
; └
;  @ /home/sumiya11/loops/writefunc.jl:66 within `selfdot`
; ┌ @ array.jl:835 within `iterate` @ array.jl:835
   br label %L20

L43:                                              ; preds = %L37.L43_crit_edge, %L18.L43_crit_edge
   %value_phi9 = phi float [ %27, %L37.L43_crit_edge ], [ 0.000000e+00, %L18.L43_crit_edge ]
; └
;  @ /home/sumiya11/loops/writefunc.jl:69 within `selfdot`
  ret float %value_phi9
}

define nonnull {}* @jfptr_selfdot_501({}* %0, {}** %1, i32 %2) #1 {
top:
  %3 = call {}*** @julia.get_pgcstack()
  %4 = getelementptr inbounds {}*, {}** %1, i32 0
  %5 = load {}*, {}** %4, align 8
  %6 = call float @julia_selfdot_500({}* %5) #0
  %7 = call {}* @jl_box_float32(float %6)
  ret {}* %7
}

declare {}*** @julia.get_pgcstack()

declare {}* @jl_box_float32(float)

attributes #0 = { "probe-stack"="inline-asm" }
attributes #1 = { "probe-stack"="inline-asm" "thunk" }

!llvm.module.flags = !{!0, !1}

!0 = !{i32 2, !"Dwarf Version", i32 4}
!1 = !{i32 2, !"Debug Info Version", i32 3}
