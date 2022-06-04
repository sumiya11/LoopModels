; ModuleID = 'vecofvec'
source_filename = "vecofvec"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128-ni:10:11:12:13"
target triple = "x86_64-unknown-linux-gnu"

;  @ /home/sumiya11/loops/writefunc.jl:99 within `vecofvec`
define nonnull {}* @japi1_vecofvec_515({}* %0, {}** %1, i32 %2) #0 {
top:
  %3 = alloca {}**, align 8
  store volatile {}** %1, {}*** %3, align 8
  %4 = call {}*** @julia.get_pgcstack()
  %5 = bitcast {}*** %4 to {}**
  %current_task = getelementptr inbounds {}*, {}** %5, i64 2305843009213693940
  %6 = bitcast {}** %current_task to i64*
  %world_age = getelementptr inbounds i64, i64* %6, i64 13
  %7 = getelementptr inbounds {}*, {}** %1, i64 0
  %8 = load {}*, {}** %7, align 8
;  @ /home/sumiya11/loops/writefunc.jl:100 within `vecofvec`
; ┌ @ array.jl:215 within `length`
   %9 = bitcast {}* %8 to { i8*, i64, i16, i16, i32 }*
   %10 = getelementptr inbounds { i8*, i64, i16, i16, i32 }, { i8*, i64, i16, i16, i32 }* %9, i32 0, i32 1
   %11 = load i64, i64* %10, align 8
; └
; ┌ @ range.jl:5 within `Colon`
; │┌ @ range.jl:354 within `UnitRange`
; ││┌ @ range.jl:359 within `unitrange_last`
; │││┌ @ operators.jl:425 within `>=`
; ││││┌ @ int.jl:477 within `<=`
       %12 = icmp sle i64 1, %11
; │││└└
     %13 = zext i1 %12 to i8
     %14 = trunc i8 %13 to i1
     %15 = xor i1 %14, true
     %16 = select i1 %15, i64 0, i64 %11
; └└└
; ┌ @ range.jl:833 within `iterate`
; │┌ @ range.jl:609 within `isempty`
; ││┌ @ operators.jl:378 within `>`
; │││┌ @ int.jl:83 within `<`
      %17 = icmp slt i64 %16, 1
; │└└└
   %18 = zext i1 %17 to i8
   %19 = trunc i8 %18 to i1
   %20 = xor i1 %19, true
   br i1 %20, label %L8, label %L6

L6:                                               ; preds = %top
   br label %L9

L8:                                               ; preds = %top
   br label %L9

L9:                                               ; preds = %L8, %L6
   %value_phi = phi i8 [ 1, %L6 ], [ 0, %L8 ]
   %value_phi1 = phi i64 [ 1, %L8 ], [ undef, %L6 ]
   %value_phi2 = phi i64 [ 1, %L8 ], [ undef, %L6 ]
; └
  %21 = xor i8 %value_phi, 1
  %22 = trunc i8 %21 to i1
  %23 = xor i1 %22, true
  br i1 %23, label %L66, label %L9.L14_crit_edge

L9.L14_crit_edge:                                 ; preds = %L9
; ┌ @ range.jl:833 within `iterate`
   br label %L14

L14:                                              ; preds = %L65, %L9.L14_crit_edge
   %value_phi3 = phi i64 [ %value_phi1, %L9.L14_crit_edge ], [ %value_phi27, %L65 ]
   %value_phi4 = phi i64 [ %value_phi2, %L9.L14_crit_edge ], [ %value_phi28, %L65 ]
; └
;  @ /home/sumiya11/loops/writefunc.jl:101 within `vecofvec`
; ┌ @ array.jl:861 within `getindex`
   %24 = sub i64 %value_phi3, 1
   %25 = mul i64 %24, 1
   %26 = add i64 0, %25
   %27 = bitcast {}* %8 to { i8*, i64, i16, i16, i32 }*
   %28 = getelementptr inbounds { i8*, i64, i16, i16, i32 }, { i8*, i64, i16, i16, i32 }* %27, i32 0, i32 0
   %29 = load i8*, i8** %28, align 8
   %30 = bitcast i8* %29 to {}**
   %31 = getelementptr inbounds {}*, {}** %30, i64 %26
   %32 = load {}*, {}** %31, align 8
   %33 = icmp ne {}* %32, null
   br i1 %33, label %pass, label %fail

L22:                                              ; preds = %pass
; └
;  @ /home/sumiya11/loops/writefunc.jl:100 within `vecofvec`
; ┌ @ range.jl:833 within `iterate`
   br label %L25

L24:                                              ; preds = %pass
   br label %L25

L25:                                              ; preds = %L24, %L22
   %value_phi5 = phi i8 [ 1, %L22 ], [ 0, %L24 ]
   %value_phi6 = phi i64 [ 2, %L24 ], [ undef, %L22 ]
   %value_phi7 = phi i64 [ 2, %L24 ], [ undef, %L22 ]
; └
;  @ /home/sumiya11/loops/writefunc.jl:101 within `vecofvec`
  %34 = xor i8 %value_phi5, 1
  %35 = trunc i8 %34 to i1
  %36 = xor i1 %35, true
  br i1 %36, label %L54, label %L25.L30_crit_edge

L25.L30_crit_edge:                                ; preds = %L25
;  @ /home/sumiya11/loops/writefunc.jl:100 within `vecofvec`
; ┌ @ range.jl:833 within `iterate`
   br label %L30

L30:                                              ; preds = %L53, %L25.L30_crit_edge
   %value_phi8 = phi i64 [ %value_phi6, %L25.L30_crit_edge ], [ %value_phi24, %L53 ]
   %value_phi9 = phi i64 [ %value_phi7, %L25.L30_crit_edge ], [ %value_phi25, %L53 ]
; └
;  @ /home/sumiya11/loops/writefunc.jl:102 within `vecofvec`
; ┌ @ array.jl:861 within `getindex`
   %37 = sub i64 %value_phi3, 1
   %38 = mul i64 %37, 1
   %39 = add i64 0, %38
   %40 = bitcast {}* %8 to { i8*, i64, i16, i16, i32 }*
   %41 = getelementptr inbounds { i8*, i64, i16, i16, i32 }, { i8*, i64, i16, i16, i32 }* %40, i32 0, i32 0
   %42 = load i8*, i8** %41, align 8
   %43 = bitcast i8* %42 to {}**
   %44 = getelementptr inbounds {}*, {}** %43, i64 %39
   %45 = load {}*, {}** %44, align 8
   %46 = icmp ne {}* %45, null
   br i1 %46, label %pass11, label %fail10

L44:                                              ; preds = %merge_own23
; └
; ┌ @ range.jl:837 within `iterate`
   br label %L48

L46:                                              ; preds = %merge_own23
; └
; ┌ @ range.jl:838 within `iterate`
; │┌ @ int.jl:87 within `+`
    %47 = add i64 %value_phi9, 1
; └└
; ┌ @ range.jl:837 within `iterate`
   br label %L48

L48:                                              ; preds = %L46, %L44
   %value_phi24 = phi i64 [ %47, %L46 ], [ undef, %L44 ]
   %value_phi25 = phi i64 [ %47, %L46 ], [ undef, %L44 ]
   %value_phi26 = phi i8 [ 1, %L44 ], [ 0, %L46 ]
; └
  %48 = xor i8 %value_phi26, 1
  %49 = trunc i8 %48 to i1
  %50 = xor i1 %49, true
  br i1 %50, label %L54, label %L53

L53:                                              ; preds = %L48
;  @ /home/sumiya11/loops/writefunc.jl:100 within `vecofvec`
; ┌ @ range.jl:833 within `iterate`
   br label %L30

L54:                                              ; preds = %L48, %L25
; └
;  @ /home/sumiya11/loops/writefunc.jl:102 within `vecofvec`
; ┌ @ range.jl:837 within `iterate`
; │┌ @ promotion.jl:468 within `==`
    %51 = icmp eq i64 %value_phi4, %16
    %52 = zext i1 %51 to i8
; │└
   %53 = trunc i8 %52 to i1
   %54 = xor i1 %53, true
   br i1 %54, label %L58, label %L56

L56:                                              ; preds = %L54
   br label %L60

L58:                                              ; preds = %L54
; └
; ┌ @ range.jl:838 within `iterate`
; │┌ @ int.jl:87 within `+`
    %55 = add i64 %value_phi4, 1
; └└
; ┌ @ range.jl:837 within `iterate`
   br label %L60

L60:                                              ; preds = %L58, %L56
   %value_phi27 = phi i64 [ %55, %L58 ], [ undef, %L56 ]
   %value_phi28 = phi i64 [ %55, %L58 ], [ undef, %L56 ]
   %value_phi29 = phi i8 [ 1, %L56 ], [ 0, %L58 ]
; └
  %56 = xor i8 %value_phi29, 1
  %57 = trunc i8 %56 to i1
  %58 = xor i1 %57, true
  br i1 %58, label %L66, label %L65

L65:                                              ; preds = %L60
;  @ /home/sumiya11/loops/writefunc.jl:100 within `vecofvec`
; ┌ @ range.jl:833 within `iterate`
   br label %L14

L66:                                              ; preds = %L60, %L9
; └
;  @ /home/sumiya11/loops/writefunc.jl:105 within `vecofvec`
  ret {}* %8

fail:                                             ; preds = %L14
;  @ /home/sumiya11/loops/writefunc.jl:101 within `vecofvec`
; ┌ @ array.jl:861 within `getindex`
   call void @jl_throw({}* inttoptr (i64 139967618240000 to {}*))
   unreachable

pass:                                             ; preds = %L14
; └
; ┌ @ array.jl:215 within `length`
   %59 = bitcast {}* %32 to { i8*, i64, i16, i16, i32 }*
   %60 = getelementptr inbounds { i8*, i64, i16, i16, i32 }, { i8*, i64, i16, i16, i32 }* %59, i32 0, i32 1
   %61 = load i64, i64* %60, align 8
; └
; ┌ @ range.jl:5 within `Colon`
; │┌ @ range.jl:354 within `UnitRange`
; ││┌ @ range.jl:359 within `unitrange_last`
; │││┌ @ operators.jl:425 within `>=`
; ││││┌ @ int.jl:477 within `<=`
       %62 = icmp sle i64 2, %61
; │││└└
     %63 = zext i1 %62 to i8
     %64 = trunc i8 %63 to i1
     %65 = xor i1 %64, true
     %66 = select i1 %65, i64 1, i64 %61
; └└└
; ┌ @ range.jl:833 within `iterate`
; │┌ @ range.jl:609 within `isempty`
; ││┌ @ operators.jl:378 within `>`
; │││┌ @ int.jl:83 within `<`
      %67 = icmp slt i64 %66, 2
; │└└└
   %68 = zext i1 %67 to i8
   %69 = trunc i8 %68 to i1
   %70 = xor i1 %69, true
   br i1 %70, label %L24, label %L22

fail10:                                           ; preds = %L30
; └
;  @ /home/sumiya11/loops/writefunc.jl:102 within `vecofvec`
; ┌ @ array.jl:861 within `getindex`
   call void @jl_throw({}* inttoptr (i64 139967618240000 to {}*))
   unreachable

pass11:                                           ; preds = %L30
   %71 = sub i64 %value_phi8, 1
   %72 = mul i64 %71, 1
   %73 = add i64 0, %72
   %74 = bitcast {}* %45 to { i8*, i64, i16, i16, i32 }*
   %75 = getelementptr inbounds { i8*, i64, i16, i16, i32 }, { i8*, i64, i16, i16, i32 }* %74, i32 0, i32 0
   %76 = load i8*, i8** %75, align 8
   %77 = bitcast i8* %76 to {}**
   %78 = getelementptr inbounds {}*, {}** %77, i64 %73
   %79 = load {}*, {}** %78, align 8
   %80 = icmp ne {}* %79, null
   br i1 %80, label %pass13, label %fail12

fail12:                                           ; preds = %pass11
   call void @jl_throw({}* inttoptr (i64 139967618240000 to {}*))
   unreachable

pass13:                                           ; preds = %pass11
   %81 = sub i64 %value_phi3, 1
   %82 = mul i64 %81, 1
   %83 = add i64 0, %82
   %84 = bitcast {}* %8 to { i8*, i64, i16, i16, i32 }*
   %85 = getelementptr inbounds { i8*, i64, i16, i16, i32 }, { i8*, i64, i16, i16, i32 }* %84, i32 0, i32 0
   %86 = load i8*, i8** %85, align 8
   %87 = bitcast i8* %86 to {}**
   %88 = getelementptr inbounds {}*, {}** %87, i64 %83
   %89 = load {}*, {}** %88, align 8
   %90 = icmp ne {}* %89, null
   br i1 %90, label %pass15, label %fail14

fail14:                                           ; preds = %pass13
   call void @jl_throw({}* inttoptr (i64 139967618240000 to {}*))
   unreachable

pass15:                                           ; preds = %pass13
; └
; ┌ @ int.jl:86 within `-`
   %91 = sub i64 %value_phi8, 1
; └
; ┌ @ array.jl:861 within `getindex`
   %92 = sub i64 %91, 1
   %93 = mul i64 %92, 1
   %94 = add i64 0, %93
   %95 = bitcast {}* %89 to { i8*, i64, i16, i16, i32 }*
   %96 = getelementptr inbounds { i8*, i64, i16, i16, i32 }, { i8*, i64, i16, i16, i32 }* %95, i32 0, i32 0
   %97 = load i8*, i8** %96, align 8
   %98 = bitcast i8* %97 to {}**
   %99 = getelementptr inbounds {}*, {}** %98, i64 %94
   %100 = load {}*, {}** %99, align 8
   %101 = icmp ne {}* %100, null
   br i1 %101, label %pass17, label %fail16

fail16:                                           ; preds = %pass15
   call void @jl_throw({}* inttoptr (i64 139967618240000 to {}*))
   unreachable

pass17:                                           ; preds = %pass15
   %102 = sub i64 %value_phi3, 1
   %103 = mul i64 %102, 1
   %104 = add i64 0, %103
   %105 = bitcast {}* %8 to { i8*, i64, i16, i16, i32 }*
   %106 = getelementptr inbounds { i8*, i64, i16, i16, i32 }, { i8*, i64, i16, i16, i32 }* %105, i32 0, i32 0
   %107 = load i8*, i8** %106, align 8
   %108 = bitcast i8* %107 to {}**
   %109 = getelementptr inbounds {}*, {}** %108, i64 %104
   %110 = load {}*, {}** %109, align 8
   %111 = icmp ne {}* %110, null
   br i1 %111, label %pass19, label %fail18

fail18:                                           ; preds = %pass17
   call void @jl_throw({}* inttoptr (i64 139967618240000 to {}*))
   unreachable

pass19:                                           ; preds = %pass17
; └
; ┌ @ int.jl:86 within `-`
   %112 = sub i64 %value_phi8, 1
; └
; ┌ @ array.jl:903 within `setindex!`
   %113 = sub i64 %112, 1
   %114 = mul i64 %113, 1
   %115 = add i64 0, %114
   %116 = bitcast {}* %110 to { i8*, i64, i16, i16, i32 }*
   %117 = getelementptr inbounds { i8*, i64, i16, i16, i32 }, { i8*, i64, i16, i16, i32 }* %116, i32 0, i32 2
   %118 = load i16, i16* %117, align 2
   %119 = and i16 %118, 3
   %120 = icmp eq i16 %119, 3
   br i1 %120, label %array_owned, label %merge_own

array_owned:                                      ; preds = %pass19
   %121 = bitcast {}* %110 to {}**
   %122 = getelementptr inbounds {}*, {}** %121, i32 5
   %123 = load {}*, {}** %122, align 8
   br label %merge_own

merge_own:                                        ; preds = %array_owned, %pass19
   %124 = phi {}* [ %110, %pass19 ], [ %123, %array_owned ]
   %125 = bitcast {}* %110 to { i8*, i64, i16, i16, i32 }*
   %126 = getelementptr inbounds { i8*, i64, i16, i16, i32 }, { i8*, i64, i16, i16, i32 }* %125, i32 0, i32 0
   %127 = bitcast i8** %126 to {}***
   %128 = load {}**, {}*** %127, align 8
   %129 = getelementptr inbounds {}*, {}** %128, i64 %115
   store atomic {}* %79, {}** %129 unordered, align 8
   call void ({}*, ...) @julia.write_barrier({}* %124, {}* %79)
; └
; ┌ @ array.jl:861 within `getindex`
   %130 = sub i64 %value_phi3, 1
   %131 = mul i64 %130, 1
   %132 = add i64 0, %131
   %133 = bitcast {}* %8 to { i8*, i64, i16, i16, i32 }*
   %134 = getelementptr inbounds { i8*, i64, i16, i16, i32 }, { i8*, i64, i16, i16, i32 }* %133, i32 0, i32 0
   %135 = load i8*, i8** %134, align 8
   %136 = bitcast i8* %135 to {}**
   %137 = getelementptr inbounds {}*, {}** %136, i64 %132
   %138 = load {}*, {}** %137, align 8
   %139 = icmp ne {}* %138, null
   br i1 %139, label %pass21, label %fail20

fail20:                                           ; preds = %merge_own
   call void @jl_throw({}* inttoptr (i64 139967618240000 to {}*))
   unreachable

pass21:                                           ; preds = %merge_own
; └
; ┌ @ array.jl:903 within `setindex!`
   %140 = sub i64 %value_phi8, 1
   %141 = mul i64 %140, 1
   %142 = add i64 0, %141
   %143 = bitcast {}* %138 to { i8*, i64, i16, i16, i32 }*
   %144 = getelementptr inbounds { i8*, i64, i16, i16, i32 }, { i8*, i64, i16, i16, i32 }* %143, i32 0, i32 2
   %145 = load i16, i16* %144, align 2
   %146 = and i16 %145, 3
   %147 = icmp eq i16 %146, 3
   br i1 %147, label %array_owned22, label %merge_own23

array_owned22:                                    ; preds = %pass21
   %148 = bitcast {}* %138 to {}**
   %149 = getelementptr inbounds {}*, {}** %148, i32 5
   %150 = load {}*, {}** %149, align 8
   br label %merge_own23

merge_own23:                                      ; preds = %array_owned22, %pass21
   %151 = phi {}* [ %138, %pass21 ], [ %150, %array_owned22 ]
   %152 = bitcast {}* %138 to { i8*, i64, i16, i16, i32 }*
   %153 = getelementptr inbounds { i8*, i64, i16, i16, i32 }, { i8*, i64, i16, i16, i32 }* %152, i32 0, i32 0
   %154 = bitcast i8** %153 to {}***
   %155 = load {}**, {}*** %154, align 8
   %156 = getelementptr inbounds {}*, {}** %155, i64 %142
   store atomic {}* %100, {}** %156 unordered, align 8
   call void ({}*, ...) @julia.write_barrier({}* %151, {}* %100)
; └
; ┌ @ range.jl:837 within `iterate`
; │┌ @ promotion.jl:468 within `==`
    %157 = icmp eq i64 %value_phi9, %66
    %158 = zext i1 %157 to i8
; │└
   %159 = trunc i8 %158 to i1
   %160 = xor i1 %159, true
   br i1 %160, label %L46, label %L44
; └
}

declare {}*** @julia.get_pgcstack()

declare void @jl_throw({}*)

declare void @julia.write_barrier({}*, ...)

attributes #0 = { "probe-stack"="inline-asm" "thunk" }

!llvm.module.flags = !{!0, !1}

!0 = !{i32 2, !"Dwarf Version", i32 4}
!1 = !{i32 2, !"Debug Info Version", i32 3}
