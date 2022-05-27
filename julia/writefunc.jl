


function write_code_llvm(f, args...; filename = nothing)
    path, io = mktemp()
    code_llvm(io, f, map(typeof, args); raw = true, dump_module = true, optimize = false, debuginfo=:none)
    close(io)
    newfilename = filename === nothing ? path * ".ll" : filename
    mv(path, newfilename)
    return newfilename
end

write_code_llvm(Float64[], Float64[], filename="julia/dotprod.ll") do a, b
    s = 0.0
    @inbounds @fastmath for i = eachindex(a, b)
        s += a[i] * b[i]
    end
    return s
end
