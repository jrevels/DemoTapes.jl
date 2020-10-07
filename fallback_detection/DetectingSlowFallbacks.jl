# Title:  Variable Capture
# Artist: Lyndon White (@oxinabox)
# Format: Literate.jl script
# License: MIT
# ---

# # What are we doing?
#
# We would like to discoure if we are hitting any slow cases for linear algebra operations.


using LinearAlgebra
using Cassette

Cassette.@context GenericLogCtx

function Cassette.prehook(
    ::GenericLogCtx,
    f::Union{
        typeof(LinearAlgebra.generic_lufact!),
        typeof(LinearAlgebra.generic_matmatmul),
        typeof(LinearAlgebra.generic_matmatmul!),
        typeof(LinearAlgebra.generic_matvecmul!),
        typeof(LinearAlgebra.generic_mul!),
    },
    args...
    )
    @info "Hit Generical Fallback" f, args=typeof.(args)
end

# This doesn't hit any
Cassette.recurse(GenericLogCtx(), function()
    Float32[1 2; 3 4] * Float64[1 2; 3 4]
end)

# this does
Cassette.recurse(GenericLogCtx(), mul!, Float32[1.0 2; 3 4], @view(Float32[1.0 2; 3 4][[1 1;4 2]]), Float32[1.0 2; 3 4], 1.0, 1.0)
