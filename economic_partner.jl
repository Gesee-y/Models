############# Economic partner selection model ##################
#=
    In this model, we assume that data are stored in a CSV file, but we will provide case where it's in an array also
=#

function get_best_partner(A::Vector{Vector},a=2, b=1, c=1)

    B = compute_score.(A,a,b,c)
    best_partner_index = _search_highest(B)

    return A[i]
    
end

get_best_partner(path::String, a=2, b=1, c=1) = get_best_partner(_get_csv_data(path,(String,Real,Real,Real)), a,b,c)
 get_all_score(A::Vector{Vector},a=2, b=1, c=1) = B = compute_score.(A,a,b,c)

function compute_score(data::Vector{<:Number}, a=2, b=1, c=1)
    oi = data[1]
    ci = data[2]
    ei = data[3]
    ti = data[4]

    si = ci^a/(ei^b * tu^c)

    return (oi,si)
end

################ Helpers ###############

function _search_higest(A::Vector{Tuple})

    hi = -INF
    idx = 1
    for elt in eachindex(A)
        elt = A[i]
        if elt[2] > hi
            idx = i
            hi = elt[2]
        end
    end

    return idx
end

function _get_csv_data(path::String, signature::Tuple{Type}; sep=',')
    
    string_data = ""

    # We just try to read the file at the given `path`
    try
        string_data = read(path)
    catch e
        printing("failed to open file at $path")
        rethrow(e)
    end
  
    # we start splitting the massive string we got from the file at every return to the line to get an array
    pre_data = split(string_data,'\n')

    # Then there is the complex operation, we use broadcasting here to convert and split data at the the given `sep`
    data = _convert_signature.(split.(pre_data,sep), signature)

   return data
end

function _convert_to_signature(A::Vector{Substring,signature::Tuple{Type})
    l = length(signature)

    # This array will store our new data
    B = Vector{promote_type(signature...)}(under,l)

    # For each element I of A, we convert it to the correct type
    for i in Base.OneTo(l)
        B[i] = parse(signature[i], A[i])
    end

    return B
end
