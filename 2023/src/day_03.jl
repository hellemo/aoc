# https://adventofcode.com/2023/day/3
using AdventOfCode
using Test
using Base.Threads: @spawn

input = "2023/data/day_03.txt"
testinput = "2023/data/test_03.txt"

function parse_data(input)
    stack(readlines(input); dims = 2)
end

const neighbours =
    let N = [i for i in CartesianIndices((-1:1, -1:1)) if i != CartesianIndex(0, 0)]
        N
    end

function legal_moves(A, p::CartesianIndex)
    return (p + a for a in neighbours if checkbounds(Bool, A, p + a))
end

function validpn(A, candidate)
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

function solve(A, CI)
    ispn = false
    candidates = Vector{CartesianIndex}[] # arrays of CIs
    candidate = CartesianIndex[] #CIs
    gears = Dict{CartesianIndex,Vector{Vector{CartesianIndex}}}()
    count = 0
    for i in CI
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
    candidates, _ = solve(A, CartesianIndices(A))
    sum(pn(A, x) for x in candidates)
end

@test part_1(testinput) == 4361
@test part_1(input) == 525119
@info "Part1:" part_1(input)

function gearprods(A, gears)
    sumgears = 0
    for g in values(gears)
        if length(g) == 2
            sumgears = sumgears + pn(A, first(g)) * pn(A, last(g))
        end
    end
    return sumgears
end

function part_2(input)
    A = parse_data(input)
    _, gears = solve(A, CartesianIndices(A))
    return gearprods(A, gears)
end

@test part_2(testinput) == 467835
@test part_2(input) == 76504829
@info "Part2:" part_2(input)

function both_parts(input, N = 10)
    A = parse_data(input)
    # Split and solve by slices:
    wsl = collect(Iterators.partition(1:size(A, 1), N))
    slices = [CartesianIndices((size(A, 1), j)) for j in wsl]
    sresults = fetch.([@spawn solve(A, s) for s in slices])
    # Merge results
    candidates = vcat(first.(sresults)...)
    gears = mergewith(vcat)(last.(sresults)...)
    # Calculate sums
    p1 = sum(pn(A, x) for x in candidates)
    p2 = gearprods(A, gears)
    return p1, p2
end
@test both_parts(testinput) == (4361, 467835)
@test both_parts(input) == (525119, 76504829)
