# https://adventofcode.com/2023/day/3
using AdventOfCode
using Test

input = "2023/data/day_03.txt"
testinput = "2023/data/test_03.txt"

function parse_data(input)
    D = split(chomp(read(input, String)), "\n")
    M = length(D)
    N = length(first(D))
    A = Array{Char}(undef, M, N)
    for i = 1:M, j = 1:N
        A[i, j] = D[i][j]
    end
    return rotr90(A)
end

function neighbours()
    [
        CartesianIndex(0, -1),
        CartesianIndex(-1, 0),
        CartesianIndex(1, 0),
        CartesianIndex(0, 1),
        CartesianIndex(-1, -1),
        CartesianIndex(-1, 1),
        CartesianIndex(1, 1),
        CartesianIndex(1, -1),
    ]
end

function legal_moves(A, p::CartesianIndex)
    return (p + a for a in neighbours() if checkbounds(Bool, A, p + a))
end

function validpn(A, candidate)
    symbol = '.'
    for i in candidate
        for n in legal_moves(A, i)
            if A[n] != '.' && !(n in candidate) && !isnumeric(A[n])
                return n => A[n]
            end
        end
    end
    return nothing
end

function add_to_gear(dict, ci, cis)
    if !haskey(dict, ci)
        dict[ci] = [cis]
    else
        push!(dict[ci], cis)
    end
end

function solve(A)
    ispn = false
    candidates = Vector{CartesianIndex}[] # arrays of CIs
    candidate =  CartesianIndex[] #CIs
    # gears = Dict{CartesianIndex,Vector{CartesianIndex}}()
    gears = Dict{CartesianIndex,Vector{Vector{CartesianIndex}}}()
    count = 0
    for i in CartesianIndices(A)
        if !ispn && isnumeric(A[i]) # New candidata
            ispn = true
            push!(candidate, i)
        elseif ispn && !isnumeric(A[i]) || first(i.I) == size(A, 1)# Completed candidate
            if isnumeric(A[i]) # Add last digit if on the edge
                push!(candidate, i)
            end
            pn = validpn(A, candidate)
            if !isnothing(pn) # For each part number
                push!(candidates, candidate)     # Store for calculation
                if last(pn) == '*'
                    add_to_gear(gears, first(pn), candidate)
                end
            end
            ispn = false
            candidate = CartesianIndex[]
        elseif ispn && isnumeric(A[i]) # Add to candidate
            push!(candidate, i)
        end
    end
    return candidates, gears
end

function pn(A, cis)
    ds = map(i -> parse(Int, A[i]), cis)
    v = 0
    for (i, d) in enumerate(reverse(ds))
        v = v + d * 10^(i - 1)
    end
    return v
end

function part_1(input)
    A = parse_data(input)
    candidates, _ = solve(A)
    sum(pn(A, x) for x in candidates)
end

@test part_1(testinput) == 4361
@test part_1(input) == 525119
@info "Part1:" part_1(input)

function part_2(input)
    A = parse_data(input)
    _, gears = solve(A)

    sumgears = 0
    for (k, v) in gears
        if length(v) == 2
            sumgears = sumgears + pn(A, first(v)) * pn(A, last(v))
        end
    end
    return sumgears
end

@test part_2(testinput) == 467835
@test part_2(input) == 76504829
@info "Part2:" part_2(input)
