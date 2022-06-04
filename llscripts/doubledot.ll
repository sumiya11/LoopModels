; ModuleID = 'doubledot'
source_filename = "doubledot"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128-ni:10:11:12:13"
target triple = "x86_64-unknown-linux-gnu"

;  @ /home/sumiya11/loops/writefunc.jl:72 within `doubledot`
define i32 @julia_doubledot_504({}* nonnull align 16 dereferenceable(40) %0, {}* nonnull align 16 dereferenceable(40) %1, {}* nonnull align 16 dereferenceable(40) %2) #0 {
top:
  %xs = alloca {}*, align 8
  %ys = alloca {}*, align 8
  %zs = alloca {}*, align 8
  %3 = alloca [1 x i64], align 8
  %4 = alloca [1 x i64], align 8
  %5 = alloca [1 x i64], align 8
  %6 = alloca [1 x i64], align 8
  %7 = call {}*** @julia.get_pgcstack()
  store {}* null, {}** %zs, align 8
  store {}* null, {}** %ys, align 8
  store {}* null, {}** %xs, align 8
  %8 = bitcast {}*** %7 to {}**
  %current_task = getelementptr inbounds {}*, {}** %8, i64 2305843009213693940
  %9 = bitcast {}** %current_task to i64*
  %world_age = getelementptr inbounds i64, i64* %9, i64 13
  store {}* %0, {}** %xs, align 8
  store {}* %1, {}** %ys, align 8
  store {}* %2, {}** %zs, align 8
;  @ /home/sumiya11/loops/writefunc.jl:75 within `doubledot`
; ┌ @ abstractarray.jl:328 within `eachindex` @ abstractarray.jl:338 @ abstractarray.jl:335
; │┌ @ abstractarray.jl:116 within `axes1`
; ││┌ @ abstractarray.jl:95 within `axes`
; │││┌ @ array.jl:151 within `size`
      %10 = load {}*, {}** %xs, align 8
      %11 = bitcast {}* %10 to {}**
      %12 = getelementptr inbounds {}*, {}** %11, i32 3
      %13 = bitcast {}** %12 to i64*
      %14 = load i64, i64* %13, align 8
; │││└
; │││┌ @ tuple.jl:221 within `map`
; ││││┌ @ range.jl:413 within `oneto`
; │││││┌ @ range.jl:411 within `OneTo` @ range.jl:398
; ││││││┌ @ promotion.jl:479 within `max`
; │││││││┌ @ int.jl:83 within `<`
          %15 = icmp slt i64 %14, 0
; │││││││└
         %16 = zext i1 %15 to i8
         %17 = trunc i8 %16 to i1
         %18 = xor i1 %17, true
         %19 = select i1 %18, i64 %14, i64 0
; │└└└└└└
; │ @ abstractarray.jl:328 within `eachindex` @ abstractarray.jl:339
; │┌ @ abstractarray.jl:345 within `_all_match_first`
; ││┌ @ abstractarray.jl:339 within `#121`
; │││┌ @ abstractarray.jl:335 within `eachindex`
; ││││┌ @ abstractarray.jl:116 within `axes1`
; │││││┌ @ abstractarray.jl:95 within `axes`
; ││││││┌ @ array.jl:151 within `size`
         %20 = load {}*, {}** %ys, align 8
         %21 = bitcast {}* %20 to {}**
         %22 = getelementptr inbounds {}*, {}** %21, i32 3
         %23 = bitcast {}** %22 to i64*
         %24 = load i64, i64* %23, align 8
; ││││││└
; ││││││┌ @ tuple.jl:221 within `map`
; │││││││┌ @ range.jl:413 within `oneto`
; ││││││││┌ @ range.jl:411 within `OneTo` @ range.jl:398
; │││││││││┌ @ promotion.jl:479 within `max`
; ││││││││││┌ @ int.jl:83 within `<`
             %25 = icmp slt i64 %24, 0
; ││││││││││└
            %26 = zext i1 %25 to i8
            %27 = trunc i8 %26 to i1
            %28 = xor i1 %27, true
            %29 = select i1 %28, i64 %24, i64 0
; ││└└└└└└└└
; ││┌ @ range.jl:1043 within `==`
; │││┌ @ range.jl:609 within `isempty`
; ││││┌ @ operators.jl:378 within `>`
; │││││┌ @ int.jl:83 within `<`
        %30 = icmp slt i64 %19, 1
; │││└└└
     %31 = zext i1 %30 to i8
     %32 = trunc i8 %31 to i1
     %33 = xor i1 %32, true
     br i1 %33, label %L11, label %L9

L9:                                               ; preds = %top
; │││┌ @ range.jl:609 within `isempty`
; ││││┌ @ operators.jl:378 within `>`
; │││││┌ @ int.jl:83 within `<`
        %34 = icmp slt i64 %29, 1
        %35 = zext i1 %34 to i8
; │││└└└
     br label %L19

L11:                                              ; preds = %top
; ││└
; ││┌ @ range.jl:1044 within `==`
; │││┌ @ range.jl:1057 within `_has_length_one`
; ││││┌ @ promotion.jl:468 within `==`
       %36 = icmp eq i64 1, %19
       %37 = zext i1 %36 to i8
; │││└└
     %38 = trunc i8 %37 to i1
     %39 = xor i1 %38, true
     br i1 %39, label %L16, label %L13

L13:                                              ; preds = %L11
; │││┌ @ range.jl:1057 within `_has_length_one`
; ││││┌ @ promotion.jl:468 within `==`
       %40 = icmp eq i64 1, %29
       %41 = zext i1 %40 to i8
; │││└└
; │││┌ @ bool.jl:38 within `&`
      %42 = and i8 %41, 1
      %43 = trunc i8 %42 to i1
      %44 = zext i1 %43 to i8
; │││└
     br label %L19

L16:                                              ; preds = %L11
; ││└
; ││┌ @ range.jl:1045 within `==` @ promotion.jl:468
     %45 = icmp eq i64 %19, %29
     %46 = zext i1 %45 to i8
; │││ @ range.jl:1045 within `==`
; │││┌ @ bool.jl:38 within `&`
      %47 = and i8 1, %46
      %48 = trunc i8 %47 to i1
      %49 = zext i1 %48 to i8
; │││└
     br label %L19

L19:                                              ; preds = %L16, %L13, %L9
     %value_phi = phi i8 [ %35, %L9 ], [ %44, %L13 ], [ %49, %L16 ]
; ││└
; ││┌ @ bool.jl:38 within `&`
     %50 = and i8 %value_phi, 1
     %51 = trunc i8 %50 to i1
; ││└
    br label %L22

L22:                                              ; preds = %L19
; │└
   %52 = zext i1 %51 to i8
   %53 = trunc i8 %52 to i1
   %54 = xor i1 %53, true
   br i1 %54, label %L24, label %L23

L23:                                              ; preds = %L22
; │ @ abstractarray.jl:328 within `eachindex` @ abstractarray.jl:341
   br label %L34

L24:                                              ; preds = %L22
; │ @ abstractarray.jl:328 within `eachindex` @ abstractarray.jl:339 @ abstractarray.jl:279
; │┌ @ abstractarray.jl:116 within `axes1`
; ││┌ @ abstractarray.jl:95 within `axes`
; │││┌ @ array.jl:151 within `size`
      %55 = load {}*, {}** %xs, align 8
      %56 = bitcast {}* %55 to {}**
      %57 = getelementptr inbounds {}*, {}** %56, i32 3
      %58 = bitcast {}** %57 to i64*
      %59 = load i64, i64* %58, align 8
; │││└
; │││┌ @ tuple.jl:221 within `map`
; ││││┌ @ range.jl:413 within `oneto`
; │││││┌ @ range.jl:411 within `OneTo` @ range.jl:398
; ││││││┌ @ promotion.jl:479 within `max`
; │││││││┌ @ int.jl:83 within `<`
          %60 = icmp slt i64 %59, 0
; │││││││└
         %61 = zext i1 %60 to i8
         %62 = trunc i8 %61 to i1
         %63 = xor i1 %62, true
         %64 = select i1 %63, i64 %59, i64 0
; ││││││└
        %65 = getelementptr inbounds [1 x i64], [1 x i64]* %5, i32 0, i32 0
        store i64 %64, i64* %65, align 8
; │└└└└└
; │ @ abstractarray.jl:328 within `eachindex` @ abstractarray.jl:339
; │┌ @ broadcast.jl:860 within `materialize`
; ││┌ @ broadcast.jl:1075 within `copy`
; │││┌ @ ntuple.jl:48 within `ntuple`
; ││││┌ @ broadcast.jl:1075 within `#29`
; │││││┌ @ broadcast.jl:643 within `_broadcast_getindex`
; ││││││┌ @ broadcast.jl:670 within `_broadcast_getindex_evalf`
; │││││││┌ @ abstractarray.jl:279 within `eachindex`
; ││││││││┌ @ abstractarray.jl:116 within `axes1`
; │││││││││┌ @ abstractarray.jl:95 within `axes`
; ││││││││││┌ @ array.jl:151 within `size`
             %66 = load {}*, {}** %ys, align 8
             %67 = bitcast {}* %66 to {}**
             %68 = getelementptr inbounds {}*, {}** %67, i32 3
             %69 = bitcast {}** %68 to i64*
             %70 = load i64, i64* %69, align 8
; ││││││││││└
; ││││││││││┌ @ tuple.jl:221 within `map`
; │││││││││││┌ @ range.jl:413 within `oneto`
; ││││││││││││┌ @ range.jl:411 within `OneTo` @ range.jl:398
; │││││││││││││┌ @ promotion.jl:479 within `max`
; ││││││││││││││┌ @ int.jl:83 within `<`
                 %71 = icmp slt i64 %70, 0
; ││││││││││││││└
                %72 = zext i1 %71 to i8
                %73 = trunc i8 %72 to i1
                %74 = xor i1 %73, true
                %75 = select i1 %74, i64 %70, i64 0
; │││││││││││││└
               %76 = getelementptr inbounds [1 x i64], [1 x i64]* %6, i32 0, i32 0
               store i64 %75, i64* %76, align 8
; │└└└└└└└└└└└└
   %77 = bitcast {}*** %7 to {}**
   %current_task26 = getelementptr inbounds {}*, {}** %77, i64 2305843009213693940
   %ptls_field27 = getelementptr inbounds {}*, {}** %current_task26, i64 14
   %ptls_load28 = load {}*, {}** %ptls_field27, align 8
   %78 = bitcast {}* %ptls_load28 to {}**
   %79 = bitcast {}** %78 to i8*
   %80 = call noalias nonnull {}* @julia.gc_alloc_obj(i8* %79, i64 8, {}* inttoptr (i64 139967573382544 to {}*)) #3
   %81 = getelementptr inbounds [1 x i64], [1 x i64]* %5, i32 0, i32 0
   %82 = bitcast {}* %80 to i64*
   %83 = load i64, i64* %81, align 8
   store i64 %83, i64* %82, align 8
   %84 = bitcast {}*** %7 to {}**
   %current_task29 = getelementptr inbounds {}*, {}** %84, i64 2305843009213693940
   %ptls_field30 = getelementptr inbounds {}*, {}** %current_task29, i64 14
   %ptls_load31 = load {}*, {}** %ptls_field30, align 8
   %85 = bitcast {}* %ptls_load31 to {}**
   %86 = bitcast {}** %85 to i8*
   %87 = call noalias nonnull {}* @julia.gc_alloc_obj(i8* %86, i64 8, {}* inttoptr (i64 139967573382544 to {}*)) #3
   %88 = getelementptr inbounds [1 x i64], [1 x i64]* %6, i32 0, i32 0
   %89 = bitcast {}* %87 to i64*
   %90 = load i64, i64* %88, align 8
   store i64 %90, i64* %89, align 8
   %91 = call cc38 nonnull {}* bitcast ({}* ({}*, {}**, i32, {}*)* @jl_invoke to {}* ({}*, {}*, {}*, {}*, {}*)*)({}* inttoptr (i64 139967594503632 to {}*), {}* inttoptr (i64 139967594505392 to {}*), {}* inttoptr (i64 139967574198336 to {}*), {}* %80, {}* %87)
   call void @llvm.trap()
   unreachable

L34:                                              ; preds = %L23
; │ @ abstractarray.jl:328 within `eachindex`
   br label %L35

L35:                                              ; preds = %L34
; └
; ┌ @ range.jl:833 within `iterate`
; │┌ @ range.jl:609 within `isempty`
; ││┌ @ operators.jl:378 within `>`
; │││┌ @ int.jl:83 within `<`
      %92 = icmp slt i64 %19, 1
; │└└└
   %93 = zext i1 %92 to i8
   %94 = trunc i8 %93 to i1
   %95 = xor i1 %94, true
   br i1 %95, label %L39, label %L37

L37:                                              ; preds = %L35
   br label %L40

L39:                                              ; preds = %L35
   br label %L40

L40:                                              ; preds = %L39, %L37
   %value_phi1 = phi i8 [ 1, %L37 ], [ 0, %L39 ]
   %value_phi2 = phi i64 [ 1, %L39 ], [ undef, %L37 ]
   %value_phi3 = phi i64 [ 1, %L39 ], [ undef, %L37 ]
; └
  %96 = xor i8 %value_phi1, 1
  %97 = trunc i8 %96 to i1
  %98 = xor i1 %97, true
  br i1 %98, label %L40.L64_crit_edge, label %L40.L45_crit_edge

L40.L64_crit_edge:                                ; preds = %L40
;  @ /home/sumiya11/loops/writefunc.jl:76 within `doubledot`
; ┌ @ range.jl:837 within `iterate`
   br label %L64

L40.L45_crit_edge:                                ; preds = %L40
; └
;  @ /home/sumiya11/loops/writefunc.jl:75 within `doubledot`
; ┌ @ range.jl:833 within `iterate`
   br label %L45

L45:                                              ; preds = %L63, %L40.L45_crit_edge
   %value_phi4 = phi i64 [ %value_phi2, %L40.L45_crit_edge ], [ %value_phi7, %L63 ]
   %value_phi5 = phi i64 [ %value_phi3, %L40.L45_crit_edge ], [ %value_phi8, %L63 ]
   %value_phi6 = phi i32 [ 0, %L40.L45_crit_edge ], [ %120, %L63 ]
; └
;  @ /home/sumiya11/loops/writefunc.jl:76 within `doubledot`
; ┌ @ array.jl:861 within `getindex`
   %99 = load {}*, {}** %xs, align 8
   %100 = sub i64 %value_phi4, 1
   %101 = mul i64 %100, 1
   %102 = add i64 0, %101
   %103 = bitcast {}* %99 to { i8*, i64, i16, i16, i32 }*
   %104 = getelementptr inbounds { i8*, i64, i16, i16, i32 }, { i8*, i64, i16, i16, i32 }* %103, i32 0, i32 0
   %105 = load i8*, i8** %104, align 8
   %106 = bitcast i8* %105 to i32*
   %107 = getelementptr inbounds i32, i32* %106, i64 %102
   %108 = load i32, i32* %107, align 4
   %109 = load {}*, {}** %ys, align 8
   %110 = sub i64 %value_phi4, 1
   %111 = mul i64 %110, 1
   %112 = add i64 0, %111
   %113 = bitcast {}* %109 to { i8*, i64, i16, i16, i32 }*
   %114 = getelementptr inbounds { i8*, i64, i16, i16, i32 }, { i8*, i64, i16, i16, i32 }* %113, i32 0, i32 0
   %115 = load i8*, i8** %114, align 8
   %116 = bitcast i8* %115 to i32*
   %117 = getelementptr inbounds i32, i32* %116, i64 %112
   %118 = load i32, i32* %117, align 4
; └
; ┌ @ int.jl:88 within `*`
   %119 = mul i32 %108, %118
; └
; ┌ @ int.jl:87 within `+`
   %120 = add i32 %value_phi6, %119
; └
; ┌ @ range.jl:837 within `iterate`
; │┌ @ promotion.jl:468 within `==`
    %121 = icmp eq i64 %value_phi5, %19
    %122 = zext i1 %121 to i8
; │└
   %123 = trunc i8 %122 to i1
   %124 = xor i1 %123, true
   br i1 %124, label %L56, label %L54

L54:                                              ; preds = %L45
   br label %L58

L56:                                              ; preds = %L45
; └
; ┌ @ range.jl:838 within `iterate`
; │┌ @ int.jl:87 within `+`
    %125 = add i64 %value_phi5, 1
; └└
; ┌ @ range.jl:837 within `iterate`
   br label %L58

L58:                                              ; preds = %L56, %L54
   %value_phi7 = phi i64 [ %125, %L56 ], [ undef, %L54 ]
   %value_phi8 = phi i64 [ %125, %L56 ], [ undef, %L54 ]
   %value_phi9 = phi i8 [ 1, %L54 ], [ 0, %L56 ]
; └
  %126 = xor i8 %value_phi9, 1
  %127 = trunc i8 %126 to i1
  %128 = xor i1 %127, true
  br i1 %128, label %L58.L64_crit_edge, label %L63

L58.L64_crit_edge:                                ; preds = %L58
; ┌ @ range.jl:837 within `iterate`
   br label %L64

L63:                                              ; preds = %L58
; └
;  @ /home/sumiya11/loops/writefunc.jl:75 within `doubledot`
; ┌ @ range.jl:833 within `iterate`
   br label %L45

L64:                                              ; preds = %L58.L64_crit_edge, %L40.L64_crit_edge
   %value_phi10 = phi i32 [ %120, %L58.L64_crit_edge ], [ 0, %L40.L64_crit_edge ]
; └
;  @ /home/sumiya11/loops/writefunc.jl:78 within `doubledot`
; ┌ @ abstractarray.jl:328 within `eachindex` @ abstractarray.jl:338 @ abstractarray.jl:335
; │┌ @ abstractarray.jl:116 within `axes1`
; ││┌ @ abstractarray.jl:95 within `axes`
; │││┌ @ array.jl:151 within `size`
      %129 = load {}*, {}** %ys, align 8
      %130 = bitcast {}* %129 to {}**
      %131 = getelementptr inbounds {}*, {}** %130, i32 3
      %132 = bitcast {}** %131 to i64*
      %133 = load i64, i64* %132, align 8
; │││└
; │││┌ @ tuple.jl:221 within `map`
; ││││┌ @ range.jl:413 within `oneto`
; │││││┌ @ range.jl:411 within `OneTo` @ range.jl:398
; ││││││┌ @ promotion.jl:479 within `max`
; │││││││┌ @ int.jl:83 within `<`
          %134 = icmp slt i64 %133, 0
; │││││││└
         %135 = zext i1 %134 to i8
         %136 = trunc i8 %135 to i1
         %137 = xor i1 %136, true
         %138 = select i1 %137, i64 %133, i64 0
; │└└└└└└
; │ @ abstractarray.jl:328 within `eachindex` @ abstractarray.jl:339
; │┌ @ abstractarray.jl:345 within `_all_match_first`
; ││┌ @ abstractarray.jl:339 within `#121`
; │││┌ @ abstractarray.jl:335 within `eachindex`
; ││││┌ @ abstractarray.jl:116 within `axes1`
; │││││┌ @ abstractarray.jl:95 within `axes`
; ││││││┌ @ array.jl:151 within `size`
         %139 = load {}*, {}** %zs, align 8
         %140 = bitcast {}* %139 to {}**
         %141 = getelementptr inbounds {}*, {}** %140, i32 3
         %142 = bitcast {}** %141 to i64*
         %143 = load i64, i64* %142, align 8
; ││││││└
; ││││││┌ @ tuple.jl:221 within `map`
; │││││││┌ @ range.jl:413 within `oneto`
; ││││││││┌ @ range.jl:411 within `OneTo` @ range.jl:398
; │││││││││┌ @ promotion.jl:479 within `max`
; ││││││││││┌ @ int.jl:83 within `<`
             %144 = icmp slt i64 %143, 0
; ││││││││││└
            %145 = zext i1 %144 to i8
            %146 = trunc i8 %145 to i1
            %147 = xor i1 %146, true
            %148 = select i1 %147, i64 %143, i64 0
; ││└└└└└└└└
; ││┌ @ range.jl:1043 within `==`
; │││┌ @ range.jl:609 within `isempty`
; ││││┌ @ operators.jl:378 within `>`
; │││││┌ @ int.jl:83 within `<`
        %149 = icmp slt i64 %138, 1
; │││└└└
     %150 = zext i1 %149 to i8
     %151 = trunc i8 %150 to i1
     %152 = xor i1 %151, true
     br i1 %152, label %L75, label %L73

L73:                                              ; preds = %L64
; │││┌ @ range.jl:609 within `isempty`
; ││││┌ @ operators.jl:378 within `>`
; │││││┌ @ int.jl:83 within `<`
        %153 = icmp slt i64 %148, 1
; └└└└└└
;  @ /home/sumiya11/loops/writefunc.jl:76 within `doubledot`
; ┌ @ range.jl:837 within `iterate`
   %154 = zext i1 %153 to i8
   br label %L83

L75:                                              ; preds = %L64
; └
;  @ /home/sumiya11/loops/writefunc.jl:78 within `doubledot`
; ┌ @ abstractarray.jl:328 within `eachindex` @ abstractarray.jl:339
; │┌ @ abstractarray.jl:345 within `_all_match_first`
; ││┌ @ range.jl:1044 within `==`
; │││┌ @ range.jl:1057 within `_has_length_one`
; ││││┌ @ promotion.jl:468 within `==`
       %155 = icmp eq i64 1, %138
       %156 = zext i1 %155 to i8
; │││└└
     %157 = trunc i8 %156 to i1
     %158 = xor i1 %157, true
     br i1 %158, label %L80, label %L77

L77:                                              ; preds = %L75
; │││┌ @ range.jl:1057 within `_has_length_one`
; ││││┌ @ promotion.jl:468 within `==`
       %159 = icmp eq i64 1, %148
       %160 = zext i1 %159 to i8
; │││└└
; │││┌ @ bool.jl:38 within `&`
      %161 = and i8 %160, 1
      %162 = trunc i8 %161 to i1
; └└└└
;  @ /home/sumiya11/loops/writefunc.jl:76 within `doubledot`
; ┌ @ range.jl:837 within `iterate`
   %163 = zext i1 %162 to i8
   br label %L83

L80:                                              ; preds = %L75
; └
;  @ /home/sumiya11/loops/writefunc.jl:78 within `doubledot`
; ┌ @ abstractarray.jl:328 within `eachindex` @ abstractarray.jl:339
; │┌ @ abstractarray.jl:345 within `_all_match_first`
; ││┌ @ range.jl:1045 within `==` @ promotion.jl:468
     %164 = icmp eq i64 %138, %148
     %165 = zext i1 %164 to i8
; │││ @ range.jl:1045 within `==`
; │││┌ @ bool.jl:38 within `&`
      %166 = and i8 1, %165
      %167 = trunc i8 %166 to i1
; └└└└
;  @ /home/sumiya11/loops/writefunc.jl:76 within `doubledot`
; ┌ @ range.jl:837 within `iterate`
   %168 = zext i1 %167 to i8
   br label %L83

L83:                                              ; preds = %L80, %L77, %L73
   %value_phi11 = phi i8 [ %154, %L73 ], [ %163, %L77 ], [ %168, %L80 ]
; └
;  @ /home/sumiya11/loops/writefunc.jl:78 within `doubledot`
; ┌ @ abstractarray.jl:328 within `eachindex` @ abstractarray.jl:339
; │┌ @ abstractarray.jl:345 within `_all_match_first`
; ││┌ @ bool.jl:38 within `&`
     %169 = and i8 %value_phi11, 1
     %170 = trunc i8 %169 to i1
; ││└
    br label %L86

L86:                                              ; preds = %L83
; │└
   %171 = zext i1 %170 to i8
   %172 = trunc i8 %171 to i1
   %173 = xor i1 %172, true
   br i1 %173, label %L88, label %L87

L87:                                              ; preds = %L86
; │ @ abstractarray.jl:328 within `eachindex` @ abstractarray.jl:341
   br label %L98

L88:                                              ; preds = %L86
; │ @ abstractarray.jl:328 within `eachindex` @ abstractarray.jl:339 @ abstractarray.jl:279
; │┌ @ abstractarray.jl:116 within `axes1`
; ││┌ @ abstractarray.jl:95 within `axes`
; │││┌ @ array.jl:151 within `size`
      %174 = load {}*, {}** %ys, align 8
      %175 = bitcast {}* %174 to {}**
      %176 = getelementptr inbounds {}*, {}** %175, i32 3
      %177 = bitcast {}** %176 to i64*
      %178 = load i64, i64* %177, align 8
; │││└
; │││┌ @ tuple.jl:221 within `map`
; ││││┌ @ range.jl:413 within `oneto`
; │││││┌ @ range.jl:411 within `OneTo` @ range.jl:398
; ││││││┌ @ promotion.jl:479 within `max`
; │││││││┌ @ int.jl:83 within `<`
          %179 = icmp slt i64 %178, 0
; │││││││└
         %180 = zext i1 %179 to i8
         %181 = trunc i8 %180 to i1
         %182 = xor i1 %181, true
         %183 = select i1 %182, i64 %178, i64 0
; ││││││└
        %184 = getelementptr inbounds [1 x i64], [1 x i64]* %3, i32 0, i32 0
        store i64 %183, i64* %184, align 8
; │└└└└└
; │ @ abstractarray.jl:328 within `eachindex` @ abstractarray.jl:339
; │┌ @ broadcast.jl:860 within `materialize`
; ││┌ @ broadcast.jl:1075 within `copy`
; │││┌ @ ntuple.jl:48 within `ntuple`
; ││││┌ @ broadcast.jl:1075 within `#29`
; │││││┌ @ broadcast.jl:643 within `_broadcast_getindex`
; ││││││┌ @ broadcast.jl:670 within `_broadcast_getindex_evalf`
; │││││││┌ @ abstractarray.jl:279 within `eachindex`
; ││││││││┌ @ abstractarray.jl:116 within `axes1`
; │││││││││┌ @ abstractarray.jl:95 within `axes`
; ││││││││││┌ @ array.jl:151 within `size`
             %185 = load {}*, {}** %zs, align 8
             %186 = bitcast {}* %185 to {}**
             %187 = getelementptr inbounds {}*, {}** %186, i32 3
             %188 = bitcast {}** %187 to i64*
             %189 = load i64, i64* %188, align 8
; ││││││││││└
; ││││││││││┌ @ tuple.jl:221 within `map`
; │││││││││││┌ @ range.jl:413 within `oneto`
; ││││││││││││┌ @ range.jl:411 within `OneTo` @ range.jl:398
; │││││││││││││┌ @ promotion.jl:479 within `max`
; ││││││││││││││┌ @ int.jl:83 within `<`
                 %190 = icmp slt i64 %189, 0
; ││││││││││││││└
                %191 = zext i1 %190 to i8
                %192 = trunc i8 %191 to i1
                %193 = xor i1 %192, true
                %194 = select i1 %193, i64 %189, i64 0
; │││││││││││││└
               %195 = getelementptr inbounds [1 x i64], [1 x i64]* %4, i32 0, i32 0
               store i64 %194, i64* %195, align 8
; │└└└└└└└└└└└└
   %196 = bitcast {}*** %7 to {}**
   %current_task22 = getelementptr inbounds {}*, {}** %196, i64 2305843009213693940
   %ptls_field = getelementptr inbounds {}*, {}** %current_task22, i64 14
   %ptls_load = load {}*, {}** %ptls_field, align 8
   %197 = bitcast {}* %ptls_load to {}**
   %198 = bitcast {}** %197 to i8*
   %199 = call noalias nonnull {}* @julia.gc_alloc_obj(i8* %198, i64 8, {}* inttoptr (i64 139967573382544 to {}*)) #3
   %200 = getelementptr inbounds [1 x i64], [1 x i64]* %3, i32 0, i32 0
   %201 = bitcast {}* %199 to i64*
   %202 = load i64, i64* %200, align 8
   store i64 %202, i64* %201, align 8
   %203 = bitcast {}*** %7 to {}**
   %current_task23 = getelementptr inbounds {}*, {}** %203, i64 2305843009213693940
   %ptls_field24 = getelementptr inbounds {}*, {}** %current_task23, i64 14
   %ptls_load25 = load {}*, {}** %ptls_field24, align 8
   %204 = bitcast {}* %ptls_load25 to {}**
   %205 = bitcast {}** %204 to i8*
   %206 = call noalias nonnull {}* @julia.gc_alloc_obj(i8* %205, i64 8, {}* inttoptr (i64 139967573382544 to {}*)) #3
   %207 = getelementptr inbounds [1 x i64], [1 x i64]* %4, i32 0, i32 0
   %208 = bitcast {}* %206 to i64*
   %209 = load i64, i64* %207, align 8
   store i64 %209, i64* %208, align 8
   %210 = call cc38 nonnull {}* bitcast ({}* ({}*, {}**, i32, {}*)* @jl_invoke to {}* ({}*, {}*, {}*, {}*, {}*)*)({}* inttoptr (i64 139967594503632 to {}*), {}* inttoptr (i64 139967594505392 to {}*), {}* inttoptr (i64 139967574198336 to {}*), {}* %199, {}* %206)
   call void @llvm.trap()
   unreachable

L98:                                              ; preds = %L87
; │ @ abstractarray.jl:328 within `eachindex`
   br label %L99

L99:                                              ; preds = %L98
; └
; ┌ @ range.jl:833 within `iterate`
; │┌ @ range.jl:609 within `isempty`
; ││┌ @ operators.jl:378 within `>`
; │││┌ @ int.jl:83 within `<`
      %211 = icmp slt i64 %138, 1
; │└└└
   %212 = zext i1 %211 to i8
   %213 = trunc i8 %212 to i1
   %214 = xor i1 %213, true
   br i1 %214, label %L103, label %L101

L101:                                             ; preds = %L99
; └
;  @ /home/sumiya11/loops/writefunc.jl:76 within `doubledot`
; ┌ @ range.jl:837 within `iterate`
   br label %L104

L103:                                             ; preds = %L99
   br label %L104

L104:                                             ; preds = %L103, %L101
   %value_phi12 = phi i8 [ 1, %L101 ], [ 0, %L103 ]
   %value_phi13 = phi i64 [ 1, %L103 ], [ undef, %L101 ]
   %value_phi14 = phi i64 [ 1, %L103 ], [ undef, %L101 ]
; └
;  @ /home/sumiya11/loops/writefunc.jl:78 within `doubledot`
  %215 = xor i8 %value_phi12, 1
  %216 = trunc i8 %215 to i1
  %217 = xor i1 %216, true
  br i1 %217, label %L104.L128_crit_edge, label %L104.L109_crit_edge

L104.L128_crit_edge:                              ; preds = %L104
;  @ /home/sumiya11/loops/writefunc.jl:79 within `doubledot`
; ┌ @ range.jl:837 within `iterate`
   br label %L128

L104.L109_crit_edge:                              ; preds = %L104
; └
;  @ /home/sumiya11/loops/writefunc.jl:76 within `doubledot`
; ┌ @ range.jl:837 within `iterate`
   br label %L109

L109:                                             ; preds = %L127, %L104.L109_crit_edge
   %value_phi15 = phi i64 [ %value_phi13, %L104.L109_crit_edge ], [ %value_phi18, %L127 ]
   %value_phi16 = phi i64 [ %value_phi14, %L104.L109_crit_edge ], [ %value_phi19, %L127 ]
   %value_phi17 = phi i32 [ 0, %L104.L109_crit_edge ], [ %239, %L127 ]
; └
;  @ /home/sumiya11/loops/writefunc.jl:79 within `doubledot`
; ┌ @ array.jl:861 within `getindex`
   %218 = load {}*, {}** %ys, align 8
   %219 = sub i64 %value_phi15, 1
   %220 = mul i64 %219, 1
   %221 = add i64 0, %220
   %222 = bitcast {}* %218 to { i8*, i64, i16, i16, i32 }*
   %223 = getelementptr inbounds { i8*, i64, i16, i16, i32 }, { i8*, i64, i16, i16, i32 }* %222, i32 0, i32 0
   %224 = load i8*, i8** %223, align 8
   %225 = bitcast i8* %224 to i32*
   %226 = getelementptr inbounds i32, i32* %225, i64 %221
   %227 = load i32, i32* %226, align 4
   %228 = load {}*, {}** %zs, align 8
   %229 = sub i64 %value_phi15, 1
   %230 = mul i64 %229, 1
   %231 = add i64 0, %230
   %232 = bitcast {}* %228 to { i8*, i64, i16, i16, i32 }*
   %233 = getelementptr inbounds { i8*, i64, i16, i16, i32 }, { i8*, i64, i16, i16, i32 }* %232, i32 0, i32 0
   %234 = load i8*, i8** %233, align 8
   %235 = bitcast i8* %234 to i32*
   %236 = getelementptr inbounds i32, i32* %235, i64 %231
   %237 = load i32, i32* %236, align 4
; └
; ┌ @ int.jl:88 within `*`
   %238 = mul i32 %227, %237
; └
; ┌ @ int.jl:87 within `+`
   %239 = add i32 %value_phi17, %238
; └
; ┌ @ range.jl:837 within `iterate`
; │┌ @ promotion.jl:468 within `==`
    %240 = icmp eq i64 %value_phi16, %138
    %241 = zext i1 %240 to i8
; │└
   %242 = trunc i8 %241 to i1
   %243 = xor i1 %242, true
   br i1 %243, label %L120, label %L118

L118:                                             ; preds = %L109
   br label %L122

L120:                                             ; preds = %L109
; └
; ┌ @ range.jl:838 within `iterate`
; │┌ @ int.jl:87 within `+`
    %244 = add i64 %value_phi16, 1
; └└
; ┌ @ range.jl:837 within `iterate`
   br label %L122

L122:                                             ; preds = %L120, %L118
   %value_phi18 = phi i64 [ %244, %L120 ], [ undef, %L118 ]
   %value_phi19 = phi i64 [ %244, %L120 ], [ undef, %L118 ]
   %value_phi20 = phi i8 [ 1, %L118 ], [ 0, %L120 ]
; └
  %245 = xor i8 %value_phi20, 1
  %246 = trunc i8 %245 to i1
  %247 = xor i1 %246, true
  br i1 %247, label %L122.L128_crit_edge, label %L127

L122.L128_crit_edge:                              ; preds = %L122
; ┌ @ range.jl:837 within `iterate`
   br label %L128

L127:                                             ; preds = %L122
; └
;  @ /home/sumiya11/loops/writefunc.jl:76 within `doubledot`
; ┌ @ range.jl:837 within `iterate`
   br label %L109

L128:                                             ; preds = %L122.L128_crit_edge, %L104.L128_crit_edge
   %value_phi21 = phi i32 [ %239, %L122.L128_crit_edge ], [ 0, %L104.L128_crit_edge ]
; └
;  @ /home/sumiya11/loops/writefunc.jl:81 within `doubledot`
; ┌ @ int.jl:87 within `+`
   %248 = add i32 %value_phi10, %value_phi21
; └
  ret i32 %248

after_noret:                                      ; No predecessors!
;  @ /home/sumiya11/loops/writefunc.jl:78 within `doubledot`
; ┌ @ abstractarray.jl:328 within `eachindex` @ abstractarray.jl:339
   unreachable

after_noret32:                                    ; No predecessors!
; └
;  @ /home/sumiya11/loops/writefunc.jl:75 within `doubledot`
; ┌ @ abstractarray.jl:328 within `eachindex` @ abstractarray.jl:339
   unreachable
; └
}

define nonnull {}* @jfptr_doubledot_505({}* %0, {}** %1, i32 %2) #1 {
top:
  %3 = call {}*** @julia.get_pgcstack()
  %4 = getelementptr inbounds {}*, {}** %1, i32 0
  %5 = load {}*, {}** %4, align 8
  %6 = getelementptr inbounds {}*, {}** %1, i32 1
  %7 = load {}*, {}** %6, align 8
  %8 = getelementptr inbounds {}*, {}** %1, i32 2
  %9 = load {}*, {}** %8, align 8
  %10 = call i32 @julia_doubledot_504({}* %5, {}* %7, {}* %9) #0
  %11 = call nonnull {}* @jl_box_int32(i32 signext %10)
  ret {}* %11
}

declare {}*** @julia.get_pgcstack()

declare {}* @jl_box_int32(i32)

declare {}* @jl_invoke({}*, {}**, i32, {}*)

declare {}* @julia.gc_alloc_obj(i8*, i64, {}*)

; Function Attrs: cold noreturn nounwind
declare void @llvm.trap() #2

attributes #0 = { "probe-stack"="inline-asm" }
attributes #1 = { "probe-stack"="inline-asm" "thunk" }
attributes #2 = { cold noreturn nounwind }
attributes #3 = { allocsize(1) }

!llvm.module.flags = !{!0, !1}

!0 = !{i32 2, !"Dwarf Version", i32 4}
!1 = !{i32 2, !"Debug Info Version", i32 3}
