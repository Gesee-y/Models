############# Economic factor selection model ##################
#=
    In this model, we assume that data are stored in a CSV file, 
    but we will provide a case where it's in an array also.
=#

function get_best_factor(A::Vector{Vector}, a=2, b=1, c=1)
    B = compute_score.(A, a, b, c)
    best_factor_index = _search_highest(B)
    
    println(B)
    return A[best_factor_index]
end

get_best_factor(path::String, a=2, b=1, c=1) = 
    get_best_factor(_get_csv_data(path, (String, Int, Int, Int)), a, b, c)

get_all_score(A::Vector{Vector}, a=2, b=1, c=1) = 
    compute_score.(A, a, b, c)

function compute_score(data::Vector, a=2, b=1, c=1)
    oi, ci, ei, ti = data  # Unpack values 
    si = ci^a / (ei^b * ti^c) 
    return (oi, abs(si))
end

################ Helpers ###############

"""
    _search_highest(A::Vector{Tuple})

This function just implement a regular search algorithm 
"""
function _search_highest(A::Vector)
    hi = -Inf  
    idx = 1
    for i in eachindex(A)
        elt = A[i] 
        if elt[2] > hi
            idx = i
            hi = elt[2]
        end
    end
    return idx
end

function _get_csv_data(path::String, signature::NTuple{S, DataType}; sep=',') where S
    string_data = ""
    try
        string_data = read(path, String)  # Ensure it's a string
    catch e
        println("Failed to open file at $path")
        rethrow(e)
    end

    pre_data = split(string_data, '\n')
    string_data = split.(pre_data, sep)

    data = Vector{Vector}(undef, length(string_data))

    for i in eachindex(data)
        if length(string_data[i]) > 1
            data[i] = _convert_to_signature(string_data[i], signature)
        end
    end

    return data
end

function _convert_to_signature(A::Vector{<:AbstractString}, signature::NTuple{S, DataType}) where S
    
    B = Vector{promote_type(signature...)}(undef, S)

    for i in Base.OneTo(S)
        B[i] = _tovalue(A[i], signature[i])
    end
    return B
end

_tovalue(s::AbstractString, T::Type{<:AbstractString}) = s
_tovalue(s::AbstractString, T::Type{<:Number}) = parse(T, s)
