; ModuleID = 'my_loop_1'
source_filename = "my_loop_1"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128-ni:10:11:12:13"
target triple = "x86_64-unknown-linux-gnu"

@jl_boxed_int8_cache = external constant [256 x {}*]

;  @ /home/sumiya11/loops/writefunc.jl:55 within `my_loop_1`
define i8 @julia_my_loop_1_494({}* nonnull align 16 dereferenceable(40) %0) #0 {
top:
  %x = alloca {}*, align 8
  %1 = call {}*** @julia.get_pgcstack()
  store {}* null, {}** %x, align 8
  %2 = bitcast {}*** %1 to {}**
  %current_task = getelementptr inbounds {}*, {}** %2, i64 2305843009213693940
  %3 = bitcast {}** %current_task to i64*
  %world_age = getelementptr inbounds i64, i64* %3, i64 13
  store {}* %0, {}** %x, align 8
;  @ /home/sumiya11/loops/writefunc.jl:57 within `my_loop_1`
; ┌ @ array.jl:215 within `length`
   %4 = load {}*, {}** %x, align 8
   %5 = bitcast {}* %4 to { i8*, i64, i16, i16, i32 }*
   %6 = getelementptr inbounds { i8*, i64, i16, i16, i32 }, { i8*, i64, i16, i16, i32 }* %5, i32 0, i32 1
   %7 = load i64, i64* %6, align 8
; └
;  @ /home/sumiya11/loops/writefunc.jl:58 within `my_loop_1`
; ┌ @ range.jl:5 within `Colon`
; │┌ @ range.jl:354 within `UnitRange`
; ││┌ @ range.jl:359 within `unitrange_last`
; │││┌ @ operators.jl:425 within `>=`
; ││││┌ @ int.jl:477 within `<=`
       %8 = icmp sle i64 1, %7
; │││└└
     %9 = zext i1 %8 to i8
     %10 = trunc i8 %9 to i1
     %11 = xor i1 %10, true
     %12 = select i1 %11, i64 0, i64 %7
; └└└
; ┌ @ range.jl:833 within `iterate`
; │┌ @ range.jl:609 within `isempty`
; ││┌ @ operators.jl:378 within `>`
; │││┌ @ int.jl:83 within `<`
      %13 = icmp slt i64 %12, 1
; │└└└
   %14 = zext i1 %13 to i8
   %15 = trunc i8 %14 to i1
   %16 = xor i1 %15, true
   br i1 %16, label %L8, label %L6

L6:                                               ; preds = %top
   br label %L9

L8:                                               ; preds = %top
   br label %L9

L9:                                               ; preds = %L8, %L6
   %value_phi = phi i8 [ 1, %L6 ], [ 0, %L8 ]
   %value_phi1 = phi i64 [ 1, %L8 ], [ undef, %L6 ]
   %value_phi2 = phi i64 [ 1, %L8 ], [ undef, %L6 ]
; └
  %17 = xor i8 %value_phi, 1
  %18 = trunc i8 %17 to i1
  %19 = xor i1 %18, true
  br i1 %19, label %L9.L31_crit_edge, label %L9.L14_crit_edge

L9.L31_crit_edge:                                 ; preds = %L9
;  @ /home/sumiya11/loops/writefunc.jl:59 within `my_loop_1`
; ┌ @ range.jl:837 within `iterate`
   br label %L31

L9.L14_crit_edge:                                 ; preds = %L9
; └
;  @ /home/sumiya11/loops/writefunc.jl:58 within `my_loop_1`
; ┌ @ range.jl:833 within `iterate`
   br label %L14

L14:                                              ; preds = %L30, %L9.L14_crit_edge
   %value_phi3 = phi i64 [ %value_phi1, %L9.L14_crit_edge ], [ %value_phi6, %L30 ]
   %value_phi4 = phi i64 [ %value_phi2, %L9.L14_crit_edge ], [ %value_phi7, %L30 ]
   %value_phi5 = phi i8 [ 0, %L9.L14_crit_edge ], [ %29, %L30 ]
; └
;  @ /home/sumiya11/loops/writefunc.jl:59 within `my_loop_1`
; ┌ @ array.jl:861 within `getindex`
   %20 = load {}*, {}** %x, align 8
   %21 = sub i64 %value_phi3, 1
   %22 = mul i64 %21, 1
   %23 = add i64 0, %22
   %24 = bitcast {}* %20 to { i8*, i64, i16, i16, i32 }*
   %25 = getelementptr inbounds { i8*, i64, i16, i16, i32 }, { i8*, i64, i16, i16, i32 }* %24, i32 0, i32 0
   %26 = load i8*, i8** %25, align 8
   %27 = getelementptr inbounds i8, i8* %26, i64 %23
   %28 = load i8, i8* %27, align 1
; └
; ┌ @ int.jl:87 within `+`
   %29 = add i8 %value_phi5, %28
; └
; ┌ @ range.jl:837 within `iterate`
; │┌ @ promotion.jl:468 within `==`
    %30 = icmp eq i64 %value_phi4, %12
    %31 = zext i1 %30 to i8
; │└
   %32 = trunc i8 %31 to i1
   %33 = xor i1 %32, true
   br i1 %33, label %L23, label %L21

L21:                                              ; preds = %L14
   br label %L25

L23:                                              ; preds = %L14
; └
; ┌ @ range.jl:838 within `iterate`
; │┌ @ int.jl:87 within `+`
    %34 = add i64 %value_phi4, 1
; └└
; ┌ @ range.jl:837 within `iterate`
   br label %L25

L25:                                              ; preds = %L23, %L21
   %value_phi6 = phi i64 [ %34, %L23 ], [ undef, %L21 ]
   %value_phi7 = phi i64 [ %34, %L23 ], [ undef, %L21 ]
   %value_phi8 = phi i8 [ 1, %L21 ], [ 0, %L23 ]
; └
  %35 = xor i8 %value_phi8, 1
  %36 = trunc i8 %35 to i1
  %37 = xor i1 %36, true
  br i1 %37, label %L25.L31_crit_edge, label %L30

L25.L31_crit_edge:                                ; preds = %L25
; ┌ @ range.jl:837 within `iterate`
   br label %L31

L30:                                              ; preds = %L25
; └
;  @ /home/sumiya11/loops/writefunc.jl:58 within `my_loop_1`
; ┌ @ range.jl:833 within `iterate`
   br label %L14

L31:                                              ; preds = %L25.L31_crit_edge, %L9.L31_crit_edge
   %value_phi9 = phi i8 [ %29, %L25.L31_crit_edge ], [ 0, %L9.L31_crit_edge ]
; └
;  @ /home/sumiya11/loops/writefunc.jl:61 within `my_loop_1`
  ret i8 %value_phi9
}

define nonnull {}* @jfptr_my_loop_1_495({}* %0, {}** %1, i32 %2) #1 {
top:
  %3 = call {}*** @julia.get_pgcstack()
  %4 = getelementptr inbounds {}*, {}** %1, i32 0
  %5 = load {}*, {}** %4, align 8
  %6 = call i8 @julia_my_loop_1_494({}* %5) #0
  %7 = zext i8 %6 to i32
  %8 = getelementptr inbounds [256 x {}*], [256 x {}*]* @jl_boxed_int8_cache, i32 0, i32 %7
  %9 = load {}*, {}** %8, align 8
  ret {}* %9
}

declare {}*** @julia.get_pgcstack()

attributes #0 = { "probe-stack"="inline-asm" }
attributes #1 = { "probe-stack"="inline-asm" "thunk" }

!llvm.module.flags = !{!0, !1}

!0 = !{i32 2, !"Dwarf Version", i32 4}
!1 = !{i32 2, !"Debug Info Version", i32 3}
