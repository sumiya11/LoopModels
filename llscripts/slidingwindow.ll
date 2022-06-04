; ModuleID = 'slidingwindow'
source_filename = "slidingwindow"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128-ni:10:11:12:13"
target triple = "x86_64-unknown-linux-gnu"

;  @ /home/sumiya11/loops/writefunc.jl:87 within `slidingwindow`
define i32 @julia_slidingwindow_508({}* nonnull align 16 dereferenceable(40) %0, i64 signext %1) #0 {
top:
  %xs = alloca {}*, align 8
  %2 = call {}*** @julia.get_pgcstack()
  store {}* null, {}** %xs, align 8
  %3 = bitcast {}*** %2 to {}**
  %current_task = getelementptr inbounds {}*, {}** %3, i64 2305843009213693940
  %4 = bitcast {}** %current_task to i64*
  %world_age = getelementptr inbounds i64, i64* %4, i64 13
  store {}* %0, {}** %xs, align 8
;  @ /home/sumiya11/loops/writefunc.jl:89 within `slidingwindow`
; ┌ @ abstractarray.jl:1147 within `isempty`
; │┌ @ array.jl:215 within `length`
    %5 = load {}*, {}** %xs, align 8
    %6 = bitcast {}* %5 to { i8*, i64, i16, i16, i32 }*
    %7 = getelementptr inbounds { i8*, i64, i16, i16, i32 }, { i8*, i64, i16, i16, i32 }* %6, i32 0, i32 1
    %8 = load i64, i64* %7, align 8
; │└
; │┌ @ promotion.jl:468 within `==`
    %9 = icmp eq i64 %8, 0
    %10 = zext i1 %9 to i8
; └└
; ┌ @ bool.jl:35 within `!`
   %11 = xor i8 %10, 1
; └
; ┌ @ /home/sumiya11/.julia/packages/VectorizationBase/cU9ca/src/llvm_intrin/intrin_funcs.jl:35 within `assume`
   call void @julia_slidingwindow_508u510(i8 %11)
; └
;  @ /home/sumiya11/loops/writefunc.jl:90 within `slidingwindow`
; ┌ @ abstractarray.jl:398 within `first`
; │┌ @ abstractarray.jl:279 within `eachindex`
; ││┌ @ abstractarray.jl:116 within `axes1`
; │││┌ @ abstractarray.jl:95 within `axes`
; ││││┌ @ array.jl:151 within `size`
       %12 = load {}*, {}** %xs, align 8
       %13 = bitcast {}* %12 to {}**
       %14 = getelementptr inbounds {}*, {}** %13, i32 3
       %15 = bitcast {}** %14 to i64*
       %16 = load i64, i64* %15, align 8
; │└└└└
; │┌ @ array.jl:861 within `getindex`
    %17 = load {}*, {}** %xs, align 8
    %18 = bitcast {}* %17 to { i8*, i64, i16, i16, i32 }*
    %19 = getelementptr inbounds { i8*, i64, i16, i16, i32 }, { i8*, i64, i16, i16, i32 }* %18, i32 0, i32 1
    %20 = load i64, i64* %19, align 8
    %21 = icmp ult i64 0, %20
    br i1 %21, label %idxend, label %oob

L13:                                              ; preds = %idxend
; └└
;  @ /home/sumiya11/loops/writefunc.jl:91 within `slidingwindow`
; ┌ @ range.jl:833 within `iterate`
   br label %L16

L15:                                              ; preds = %idxend
   br label %L16

L16:                                              ; preds = %L15, %L13
   %value_phi = phi i8 [ 1, %L13 ], [ 0, %L15 ]
   %value_phi1 = phi i64 [ 1, %L15 ], [ undef, %L13 ]
   %value_phi2 = phi i64 [ 1, %L15 ], [ undef, %L13 ]
; └
  %22 = xor i8 %value_phi, 1
  %23 = trunc i8 %22 to i1
  %24 = xor i1 %23, true
  br i1 %24, label %L16.L69_crit_edge, label %L16.L21_crit_edge

L16.L69_crit_edge:                                ; preds = %L16
;  @ /home/sumiya11/loops/writefunc.jl:93 within `slidingwindow`
; ┌ @ range.jl:837 within `iterate`
   br label %L69

L16.L21_crit_edge:                                ; preds = %L16
; └
;  @ /home/sumiya11/loops/writefunc.jl:91 within `slidingwindow`
; ┌ @ range.jl:833 within `iterate`
   br label %L21

L21:                                              ; preds = %L68, %L16.L21_crit_edge
   %value_phi3 = phi i64 [ %value_phi1, %L16.L21_crit_edge ], [ %value_phi16, %L68 ]
   %value_phi4 = phi i64 [ %value_phi2, %L16.L21_crit_edge ], [ %value_phi17, %L68 ]
   %value_phi5 = phi i32 [ %77, %L16.L21_crit_edge ], [ %value_phi15, %L68 ]
; └
;  @ /home/sumiya11/loops/writefunc.jl:92 within `slidingwindow`
; ┌ @ int.jl:87 within `+`
   %25 = add i64 %value_phi3, %1
; └
; ┌ @ range.jl:5 within `Colon`
; │┌ @ range.jl:354 within `UnitRange`
; ││┌ @ range.jl:359 within `unitrange_last`
; │││┌ @ operators.jl:425 within `>=`
; ││││┌ @ int.jl:477 within `<=`
       %26 = icmp sle i64 %value_phi3, %25
; │││└└
; │││┌ @ int.jl:86 within `-`
      %27 = sub i64 %value_phi3, 1
; │││└
     %28 = zext i1 %26 to i8
     %29 = trunc i8 %28 to i1
     %30 = xor i1 %29, true
     %31 = select i1 %30, i64 %27, i64 %25
; └└└
; ┌ @ range.jl:833 within `iterate`
; │┌ @ range.jl:609 within `isempty`
; ││┌ @ operators.jl:378 within `>`
; │││┌ @ int.jl:83 within `<`
      %32 = icmp slt i64 %31, %value_phi3
; │└└└
   %33 = zext i1 %32 to i8
   %34 = trunc i8 %33 to i1
   %35 = xor i1 %34, true
   br i1 %35, label %L32, label %L30

L30:                                              ; preds = %L21
; └
;  @ /home/sumiya11/loops/writefunc.jl:91 within `slidingwindow`
; ┌ @ range.jl:833 within `iterate`
   br label %L33

L32:                                              ; preds = %L21
   br label %L33

L33:                                              ; preds = %L32, %L30
   %value_phi6 = phi i8 [ 1, %L30 ], [ 0, %L32 ]
   %value_phi7 = phi i64 [ %value_phi3, %L32 ], [ undef, %L30 ]
   %value_phi8 = phi i64 [ %value_phi3, %L32 ], [ undef, %L30 ]
; └
;  @ /home/sumiya11/loops/writefunc.jl:92 within `slidingwindow`
  %36 = xor i8 %value_phi6, 1
  %37 = trunc i8 %36 to i1
  %38 = xor i1 %37, true
  br i1 %38, label %L33.L56_crit_edge, label %L33.L38_crit_edge

L33.L56_crit_edge:                                ; preds = %L33
;  @ /home/sumiya11/loops/writefunc.jl:93 within `slidingwindow`
; ┌ @ range.jl:837 within `iterate`
   br label %L56

L33.L38_crit_edge:                                ; preds = %L33
; └
;  @ /home/sumiya11/loops/writefunc.jl:91 within `slidingwindow`
; ┌ @ range.jl:833 within `iterate`
   br label %L38

L38:                                              ; preds = %L55, %L33.L38_crit_edge
   %value_phi9 = phi i32 [ %value_phi5, %L33.L38_crit_edge ], [ %53, %L55 ]
   %value_phi10 = phi i64 [ %value_phi7, %L33.L38_crit_edge ], [ %value_phi12, %L55 ]
   %value_phi11 = phi i64 [ %value_phi8, %L33.L38_crit_edge ], [ %value_phi13, %L55 ]
; └
;  @ /home/sumiya11/loops/writefunc.jl:93 within `slidingwindow`
; ┌ @ array.jl:861 within `getindex`
   %39 = load {}*, {}** %xs, align 8
   %40 = sub i64 %value_phi10, 1
   %41 = mul i64 %40, 1
   %42 = add i64 0, %41
   %43 = bitcast {}* %39 to { i8*, i64, i16, i16, i32 }*
   %44 = getelementptr inbounds { i8*, i64, i16, i16, i32 }, { i8*, i64, i16, i16, i32 }* %43, i32 0, i32 0
   %45 = load i8*, i8** %44, align 8
   %46 = bitcast i8* %45 to i32*
   %47 = getelementptr inbounds i32, i32* %46, i64 %42
   %48 = load i32, i32* %47, align 4
; └
; ┌ @ promotion.jl:479 within `max`
; │┌ @ int.jl:83 within `<`
    %49 = icmp slt i32 %48, %value_phi9
; │└
   %50 = zext i1 %49 to i8
   %51 = trunc i8 %50 to i1
   %52 = xor i1 %51, true
   %53 = select i1 %52, i32 %48, i32 %value_phi9
; └
; ┌ @ range.jl:837 within `iterate`
; │┌ @ promotion.jl:468 within `==`
    %54 = icmp eq i64 %value_phi11, %31
    %55 = zext i1 %54 to i8
; │└
   %56 = trunc i8 %55 to i1
   %57 = xor i1 %56, true
   br i1 %57, label %L48, label %L46

L46:                                              ; preds = %L38
   br label %L50

L48:                                              ; preds = %L38
; └
; ┌ @ range.jl:838 within `iterate`
; │┌ @ int.jl:87 within `+`
    %58 = add i64 %value_phi11, 1
; └└
; ┌ @ range.jl:837 within `iterate`
   br label %L50

L50:                                              ; preds = %L48, %L46
   %value_phi12 = phi i64 [ %58, %L48 ], [ undef, %L46 ]
   %value_phi13 = phi i64 [ %58, %L48 ], [ undef, %L46 ]
   %value_phi14 = phi i8 [ 1, %L46 ], [ 0, %L48 ]
; └
  %59 = xor i8 %value_phi14, 1
  %60 = trunc i8 %59 to i1
  %61 = xor i1 %60, true
  br i1 %61, label %L50.L56_crit_edge, label %L55

L50.L56_crit_edge:                                ; preds = %L50
; ┌ @ range.jl:837 within `iterate`
   br label %L56

L55:                                              ; preds = %L50
; └
;  @ /home/sumiya11/loops/writefunc.jl:91 within `slidingwindow`
; ┌ @ range.jl:833 within `iterate`
   br label %L38

L56:                                              ; preds = %L50.L56_crit_edge, %L33.L56_crit_edge
   %value_phi15 = phi i32 [ %53, %L50.L56_crit_edge ], [ %value_phi5, %L33.L56_crit_edge ]
; └
;  @ /home/sumiya11/loops/writefunc.jl:93 within `slidingwindow`
; ┌ @ range.jl:837 within `iterate`
; │┌ @ promotion.jl:468 within `==`
    %62 = icmp eq i64 %value_phi4, %87
    %63 = zext i1 %62 to i8
; │└
   %64 = trunc i8 %63 to i1
   %65 = xor i1 %64, true
   br i1 %65, label %L61, label %L59

L59:                                              ; preds = %L56
   br label %L63

L61:                                              ; preds = %L56
; └
; ┌ @ range.jl:838 within `iterate`
; │┌ @ int.jl:87 within `+`
    %66 = add i64 %value_phi4, 1
; └└
; ┌ @ range.jl:837 within `iterate`
   br label %L63

L63:                                              ; preds = %L61, %L59
   %value_phi16 = phi i64 [ %66, %L61 ], [ undef, %L59 ]
   %value_phi17 = phi i64 [ %66, %L61 ], [ undef, %L59 ]
   %value_phi18 = phi i8 [ 1, %L59 ], [ 0, %L61 ]
; └
  %67 = xor i8 %value_phi18, 1
  %68 = trunc i8 %67 to i1
  %69 = xor i1 %68, true
  br i1 %69, label %L63.L69_crit_edge, label %L68

L63.L69_crit_edge:                                ; preds = %L63
; ┌ @ range.jl:837 within `iterate`
   br label %L69

L68:                                              ; preds = %L63
; └
;  @ /home/sumiya11/loops/writefunc.jl:91 within `slidingwindow`
; ┌ @ range.jl:833 within `iterate`
   br label %L21

L69:                                              ; preds = %L63.L69_crit_edge, %L16.L69_crit_edge
   %value_phi19 = phi i32 [ %value_phi15, %L63.L69_crit_edge ], [ %77, %L16.L69_crit_edge ]
; └
;  @ /home/sumiya11/loops/writefunc.jl:96 within `slidingwindow`
  ret i32 %value_phi19

oob:                                              ; preds = %top
;  @ /home/sumiya11/loops/writefunc.jl:90 within `slidingwindow`
; ┌ @ abstractarray.jl:398 within `first`
; │┌ @ array.jl:861 within `getindex`
    %70 = alloca i64, i64 1, align 8
    %71 = getelementptr inbounds i64, i64* %70, i64 0
    store i64 1, i64* %71, align 8
    call void @jl_bounds_error_ints({}* %17, i64* %70, i64 1)
    unreachable

idxend:                                           ; preds = %top
    %72 = bitcast {}* %17 to { i8*, i64, i16, i16, i32 }*
    %73 = getelementptr inbounds { i8*, i64, i16, i16, i32 }, { i8*, i64, i16, i16, i32 }* %72, i32 0, i32 0
    %74 = load i8*, i8** %73, align 8
    %75 = bitcast i8* %74 to i32*
    %76 = getelementptr inbounds i32, i32* %75, i64 0
    %77 = load i32, i32* %76, align 4
; └└
;  @ /home/sumiya11/loops/writefunc.jl:91 within `slidingwindow`
; ┌ @ array.jl:215 within `length`
   %78 = load {}*, {}** %xs, align 8
   %79 = bitcast {}* %78 to { i8*, i64, i16, i16, i32 }*
   %80 = getelementptr inbounds { i8*, i64, i16, i16, i32 }, { i8*, i64, i16, i16, i32 }* %79, i32 0, i32 1
   %81 = load i64, i64* %80, align 8
; └
; ┌ @ int.jl:86 within `-`
   %82 = sub i64 %81, %1
; └
; ┌ @ range.jl:5 within `Colon`
; │┌ @ range.jl:354 within `UnitRange`
; ││┌ @ range.jl:359 within `unitrange_last`
; │││┌ @ operators.jl:425 within `>=`
; ││││┌ @ int.jl:477 within `<=`
       %83 = icmp sle i64 1, %82
; │││└└
     %84 = zext i1 %83 to i8
     %85 = trunc i8 %84 to i1
     %86 = xor i1 %85, true
     %87 = select i1 %86, i64 0, i64 %82
; └└└
; ┌ @ range.jl:833 within `iterate`
; │┌ @ range.jl:609 within `isempty`
; ││┌ @ operators.jl:378 within `>`
; │││┌ @ int.jl:83 within `<`
      %88 = icmp slt i64 %87, 1
; │└└└
   %89 = zext i1 %88 to i8
   %90 = trunc i8 %89 to i1
   %91 = xor i1 %90, true
   br i1 %91, label %L15, label %L13
; └
}

define nonnull {}* @jfptr_slidingwindow_509({}* %0, {}** %1, i32 %2) #1 {
top:
  %3 = call {}*** @julia.get_pgcstack()
  %4 = getelementptr inbounds {}*, {}** %1, i32 0
  %5 = load {}*, {}** %4, align 8
  %6 = getelementptr inbounds {}*, {}** %1, i32 1
  %7 = load {}*, {}** %6, align 8
  %8 = bitcast {}* %7 to i64*
  %9 = load i64, i64* %8, align 8
  %10 = call i32 @julia_slidingwindow_508({}* %5, i64 signext %9) #0
  %11 = call nonnull {}* @jl_box_int32(i32 signext %10)
  ret {}* %11
}

declare {}*** @julia.get_pgcstack()

declare {}* @jl_box_int32(i32)

declare void @jl_bounds_error_ints({}*, i64*, i64)

; Function Attrs: alwaysinline
define private void @julia_slidingwindow_508u510(i8 %0) #2 {
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
