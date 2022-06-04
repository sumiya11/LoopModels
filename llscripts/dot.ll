; ModuleID = 'my_dot'
source_filename = "my_dot"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128-ni:10:11:12:13"
target triple = "x86_64-unknown-linux-gnu"

;  @ /home/sumiya11/loops/writefunc.jl:47 within `my_dot`
define i64 @julia_my_dot_469({}* nonnull align 16 dereferenceable(40) %0, {}* nonnull align 16 dereferenceable(40) %1) #0 {
top:
  %x = alloca {}*, align 8
  %y = alloca {}*, align 8
  %2 = call {}*** @julia.get_pgcstack()
  store {}* null, {}** %y, align 8
  store {}* null, {}** %x, align 8
  %3 = bitcast {}*** %2 to {}**
  %current_task = getelementptr inbounds {}*, {}** %3, i64 2305843009213693940
  %4 = bitcast {}** %current_task to i64*
  %world_age = getelementptr inbounds i64, i64* %4, i64 13
  store {}* %0, {}** %x, align 8
  store {}* %1, {}** %y, align 8
;  @ /home/sumiya11/loops/writefunc.jl:49 within `my_dot`
; ┌ @ array.jl:215 within `length`
   %5 = load {}*, {}** %x, align 8
   %6 = bitcast {}* %5 to { i8*, i64, i16, i16, i32 }*
   %7 = getelementptr inbounds { i8*, i64, i16, i16, i32 }, { i8*, i64, i16, i16, i32 }* %6, i32 0, i32 1
   %8 = load i64, i64* %7, align 8
; └
; ┌ @ range.jl:5 within `Colon`
; │┌ @ range.jl:354 within `UnitRange`
; ││┌ @ range.jl:359 within `unitrange_last`
; │││┌ @ operators.jl:425 within `>=`
; ││││┌ @ int.jl:477 within `<=`
       %9 = icmp sle i64 1, %8
; │││└└
     %10 = zext i1 %9 to i8
     %11 = trunc i8 %10 to i1
     %12 = xor i1 %11, true
     %13 = select i1 %12, i64 0, i64 %8
; └└└
; ┌ @ range.jl:833 within `iterate`
; │┌ @ range.jl:609 within `isempty`
; ││┌ @ operators.jl:378 within `>`
; │││┌ @ int.jl:83 within `<`
      %14 = icmp slt i64 %13, 1
; │└└└
   %15 = zext i1 %14 to i8
   %16 = trunc i8 %15 to i1
   %17 = xor i1 %16, true
   br i1 %17, label %L8, label %L6

L6:                                               ; preds = %top
   br label %L9

L8:                                               ; preds = %top
   br label %L9

L9:                                               ; preds = %L8, %L6
   %value_phi = phi i8 [ 1, %L6 ], [ 0, %L8 ]
   %value_phi1 = phi i64 [ 1, %L8 ], [ undef, %L6 ]
   %value_phi2 = phi i64 [ 1, %L8 ], [ undef, %L6 ]
; └
  %18 = xor i8 %value_phi, 1
  %19 = trunc i8 %18 to i1
  %20 = xor i1 %19, true
  br i1 %20, label %L9.L33_crit_edge, label %L9.L14_crit_edge

L9.L33_crit_edge:                                 ; preds = %L9
;  @ /home/sumiya11/loops/writefunc.jl:50 within `my_dot`
; ┌ @ range.jl:837 within `iterate`
   br label %L33

L9.L14_crit_edge:                                 ; preds = %L9
; └
;  @ /home/sumiya11/loops/writefunc.jl:49 within `my_dot`
; ┌ @ range.jl:833 within `iterate`
   br label %L14

L14:                                              ; preds = %L32, %L9.L14_crit_edge
   %value_phi3 = phi i64 [ %value_phi1, %L9.L14_crit_edge ], [ %value_phi6, %L32 ]
   %value_phi4 = phi i64 [ %value_phi2, %L9.L14_crit_edge ], [ %value_phi7, %L32 ]
   %value_phi5 = phi i64 [ 0, %L9.L14_crit_edge ], [ %42, %L32 ]
; └
;  @ /home/sumiya11/loops/writefunc.jl:50 within `my_dot`
; ┌ @ array.jl:861 within `getindex`
   %21 = load {}*, {}** %x, align 8
   %22 = sub i64 %value_phi3, 1
   %23 = mul i64 %22, 1
   %24 = add i64 0, %23
   %25 = bitcast {}* %21 to { i8*, i64, i16, i16, i32 }*
   %26 = getelementptr inbounds { i8*, i64, i16, i16, i32 }, { i8*, i64, i16, i16, i32 }* %25, i32 0, i32 0
   %27 = load i8*, i8** %26, align 8
   %28 = bitcast i8* %27 to i64*
   %29 = getelementptr inbounds i64, i64* %28, i64 %24
   %30 = load i64, i64* %29, align 8
   %31 = load {}*, {}** %y, align 8
   %32 = sub i64 %value_phi3, 1
   %33 = mul i64 %32, 1
   %34 = add i64 0, %33
   %35 = bitcast {}* %31 to { i8*, i64, i16, i16, i32 }*
   %36 = getelementptr inbounds { i8*, i64, i16, i16, i32 }, { i8*, i64, i16, i16, i32 }* %35, i32 0, i32 0
   %37 = load i8*, i8** %36, align 8
   %38 = bitcast i8* %37 to i64*
   %39 = getelementptr inbounds i64, i64* %38, i64 %34
   %40 = load i64, i64* %39, align 8
; └
; ┌ @ int.jl:88 within `*`
   %41 = mul i64 %30, %40
; └
; ┌ @ int.jl:87 within `+`
   %42 = add i64 %value_phi5, %41
; └
; ┌ @ range.jl:837 within `iterate`
; │┌ @ promotion.jl:468 within `==`
    %43 = icmp eq i64 %value_phi4, %13
    %44 = zext i1 %43 to i8
; │└
   %45 = trunc i8 %44 to i1
   %46 = xor i1 %45, true
   br i1 %46, label %L25, label %L23

L23:                                              ; preds = %L14
   br label %L27

L25:                                              ; preds = %L14
; └
; ┌ @ range.jl:838 within `iterate`
; │┌ @ int.jl:87 within `+`
    %47 = add i64 %value_phi4, 1
; └└
; ┌ @ range.jl:837 within `iterate`
   br label %L27

L27:                                              ; preds = %L25, %L23
   %value_phi6 = phi i64 [ %47, %L25 ], [ undef, %L23 ]
   %value_phi7 = phi i64 [ %47, %L25 ], [ undef, %L23 ]
   %value_phi8 = phi i8 [ 1, %L23 ], [ 0, %L25 ]
; └
  %48 = xor i8 %value_phi8, 1
  %49 = trunc i8 %48 to i1
  %50 = xor i1 %49, true
  br i1 %50, label %L27.L33_crit_edge, label %L32

L27.L33_crit_edge:                                ; preds = %L27
; ┌ @ range.jl:837 within `iterate`
   br label %L33

L32:                                              ; preds = %L27
; └
;  @ /home/sumiya11/loops/writefunc.jl:49 within `my_dot`
; ┌ @ range.jl:833 within `iterate`
   br label %L14

L33:                                              ; preds = %L27.L33_crit_edge, %L9.L33_crit_edge
   %value_phi9 = phi i64 [ %42, %L27.L33_crit_edge ], [ 0, %L9.L33_crit_edge ]
; └
;  @ /home/sumiya11/loops/writefunc.jl:52 within `my_dot`
  ret i64 %value_phi9
}

define nonnull {}* @jfptr_my_dot_470({}* %0, {}** %1, i32 %2) #1 {
top:
  %3 = call {}*** @julia.get_pgcstack()
  %4 = getelementptr inbounds {}*, {}** %1, i32 0
  %5 = load {}*, {}** %4, align 8
  %6 = getelementptr inbounds {}*, {}** %1, i32 1
  %7 = load {}*, {}** %6, align 8
  %8 = call i64 @julia_my_dot_469({}* %5, {}* %7) #0
  %9 = call nonnull {}* @jl_box_int64(i64 signext %8)
  ret {}* %9
}

declare {}*** @julia.get_pgcstack()

declare {}* @jl_box_int64(i64)

attributes #0 = { "probe-stack"="inline-asm" }
attributes #1 = { "probe-stack"="inline-asm" "thunk" }

!llvm.module.flags = !{!0, !1}

!0 = !{i32 2, !"Dwarf Version", i32 4}
!1 = !{i32 2, !"Debug Info Version", i32 3}
