
using VectorizationBase: assume

struct Dual
    x::Float32
    y::Float32
    Dual(x, y) = new(x, y)
    Dual() = Dual(0.0f0, 0.0f0)
end

function dualsum(a::Dual, b::Dual)
    assume( !iszero(a.x) )
    assume( !iszero(b.x) )

    Dual(a.x + b.x, a.y + b.y)
end

function my_id(x::Int)
    return x
end

function my_sum(x::Int, y::Int)
    assume(y > 0)
    x = x + y
    return y - x
end

function my_dot(x::Vector{Int}, y::Vector{Int})
    s = 0
    @inbounds for i in 1:length(x)
        s += x[i]*y[i]
    end
    return s
end

function my_sqrt1(x::Float32)
    sqrt(x)
end

function my_sqrt2(x::Float32)
    assume( x >= 0.0f0 )
    assume( !(x < 0f0) )

    sqrt(x)
end

function my_dot(x::Vector{Int}, y::Vector{Int})
    s = 0
    @inbounds for i in 1:length(x)
        s += x[i]*y[i]
    end
    return s
end

function my_loop_1(x::Vector{T}) where {T}
    s = T(0)
    n = length(x)
    @inbounds for i in 1:n
        s += x[i]
    end
    return s
end

function selfdot(xs::Vector{T}) where {T}
    s = zero(T)
    for x in xs
        s += x
    end
    s
end

function doubledot(xs::Vector{T}, ys::Vector{T}, zs::Vector{T}) where {T}
    # returns dot(xs,ys) + dot(ys,zs)
    s1, s2 = zero(T), zero(T)
    @inbounds for i in eachindex(xs, ys)
        s1 += xs[i]*ys[i]
    end
    @inbounds for i in eachindex(ys, zs)
        s2 += ys[i]*zs[i]
    end
    s1 + s2
end

#=
    Double check the IR.. why 4 loops?
=#
function slidingwindow(xs::Vector{T}, width::Int) where {T}
    # returns dot(xs,ys) + dot(ys,zs)
    assume( !isempty(xs) )
    s1 = first(xs)
    @inbounds for i in 1:length(xs)-width
        for j in i:i+width
            s1 = max(s1, xs[j]) 
        end
    end
    s1
end

#=
    Double check the IR.. why UNREACHABLE executed?
=#
function vecofvec(A::Vector{Vector{T}}) where {T}
    @inbounds for i in 1:length(A)
        for j in 2:length(A[i])
             A[i][j - 1], A[i][j] = A[i][j], A[i][j - 1]
        end
    end
    A
end

function write_code_llvm(f, args...;
                            filename = nothing)
    path, io = mktemp()
    code_llvm(io, f, map(typeof, args); 
                raw = false, 
                dump_module = true, 
                optimize = false, 
                debuginfo = :default)
    close(io)
    newfilename = filename === nothing ? path * ".ll" : filename
    newfilename = "llscripts/" * newfilename
    mv(path, newfilename, force = true)
    return newfilename
end

function clean_llvm(filename, newfilename,
                        passes = "default<Oz>,function(simplifycfg,instcombine,early-cse,loop-rotate,lcssa)")
    filename = "llscripts/" * filename
    newfilename = "llscripts/" * newfilename
    run(`opt --passes="$passes" $filename -S -o $newfilename`)
    return newfilename
end

# fn1 = "identity.ll"
# fn1_clean = "identity_clean.ll"
# write_code_llvm(my_id, 1, filename=fn1)
# clean_llvm(fn1, fn1_clean)

fn2 = "sum.ll"
fn2_clean = "sum_clean.ll"
write_code_llvm(my_sum, 1, 2, filename=fn2)
clean_llvm(fn2, fn2_clean)


fn3 = "dot.ll"
fn3_clean = "dot_clean.ll"
write_code_llvm(my_dot, Int[], Int[], filename=fn3)
clean_llvm(fn3, fn3_clean)

fn4 = "dualsum.ll"
fn4_clean = "dualsum_clean.ll"
write_code_llvm(dualsum, Dual(), Dual(), filename=fn4)
clean_llvm(fn4, fn4_clean)

fn5 = "my_sqrt1.ll"
fn5_clean = "my_sqrt1_clean.ll"
write_code_llvm(my_sqrt1, 0.0f0, filename=fn5)
clean_llvm(fn5, fn5_clean)

fn6 = "my_sqrt2.ll"
fn6_clean = "my_sqrt2_clean.ll"
write_code_llvm(my_sqrt2, 0.0f0, filename=fn6)
clean_llvm(fn6, fn6_clean)

fn7 = "my_loop_1.ll"
fn7_clean = "my_loop_1_clean.ll"
write_code_llvm(my_loop_1, Int8[], filename=fn7)
clean_llvm(fn7, fn7_clean)

fn8 = "selfdot.ll"
fn8_clean = "selfdot_clean.ll"
write_code_llvm(selfdot, Float32[], filename=fn8)
clean_llvm(fn8, fn8_clean)

fn9 = "doubledot.ll"
fn9_clean = "doubledot_clean.ll"
write_code_llvm(doubledot, Int32[], Int32[], Int32[], filename=fn9)
clean_llvm(fn9, fn9_clean)

fn10 = "slidingwindow.ll"
fn10_clean = "slidingwindow_clean.ll"
write_code_llvm(slidingwindow, Int32[], 3, filename=fn10)
clean_llvm(fn10, fn10_clean)

fn11 = "vecofvecofvec.ll"
fn11_clean = "vecofvecofvec_clean.ll"
write_code_llvm(vecofvec, Vector{Vector{Vector}}(undef, 0), filename=fn11)
clean_llvm(fn11, fn11_clean)