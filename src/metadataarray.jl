"""
    MetadataArray(parent::AbstractArray, metadata)

Custom `AbstractArray` object to store an `AbstractArray` `parent` as well as some `metadata`.

# Examples

```jldoctest metadataarray
julia> v = ["John", "John", "Jane", "Louise"];

julia> s = MetadataArray(v, Dict("John" => "Treatment", "Louise" => "Placebo", "Jane" => "Placebo"))
4-element MetadataArrays.MetadataArray{String,Dict{String,String},1,Array{String,1}}:
 "John"
 "John"
 "Jane"
 "Louise"

julia> metadata(s)
Dict{String,String} with 3 entries:
  "John"   => "Treatment"
  "Jane"   => "Placebo"
  "Louise" => "Placebo"
```
"""
struct MetadataArray{T, M, N, S<:AbstractArray} <: AbstractArray{T, N}
    parent::S
    metadata::M
end

MetadataArray(v::AbstractArray{T, N}, m::M = ()) where {T, N, M} =
     MetadataArray{T, M, N, typeof(v)}(v, m)

"""
    MetadataVector{T, M, S<:AbstractArray}

Shorthand for `MetadataArray{T, M, 1, S}`.
"""
const MetadataVector{T, M, S<:AbstractArray} = MetadataArray{T, M, 1, S}

MetadataVector(v::AbstractVector, n = (0,); default = missing) = MetadataArray(v, n; default = default)

Base.size(s::MetadataArray) = Base.size(parent(s))

function Base.getindex(s::MetadataArray{T, M, N}, x::Vararg{Int, N}) where {T, M, N}
    getindex(parent(s), x...)
end

function Base.setindex!(s::MetadataArray{T, M, N}, el, x::Vararg{Int, N}) where {T, M, N}
    setindex!(parent(s), el, x...)
end

Base.parent(s::MetadataArray) = s.parent

"""
    metadata(s::MetadataArray)

Returns metadata for `s`.
"""
metadata(s::MetadataArray) = s.metadata