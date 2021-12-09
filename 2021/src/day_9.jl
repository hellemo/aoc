# https://adventofcode.com/2021/day/9
using AdventOfCode
using Test

input = readlines("2021/data/day_9.txt")
testinput = readlines("2021/data/day_9_test.txt")

function parse_input(input)
    N = length(input)
    M = length(first(input))
    A = zeros(UInt8, N, M)
    for i = 1:N
        row = parse.(UInt8, (c for c in input[i]))
        for j = 1:M
            @views A[i, j] = row[j]
        end
    end
    return A
end

# neighbours() = filter(x->abs(x.I[1]) ≠ abs(x.I[2]), CartesianIndices((-1:1, -1:1))) 
# Literals more type stable and faster (thanks to JET.jl)
function neighbours()
    [CartesianIndex( 0, -1),
     CartesianIndex(-1,  0),
     CartesianIndex( 1,  0),
     CartesianIndex( 0,  1),]
end

function is_lowpoint(A, p::CartesianIndex)
    for a in neighbours()
        ap = p + a
        checkbounds(Bool, A, ap) && A[p] >= A[ap] && return false
    end
    return true
end

risk_level(x) = x + 1

function part_1(input)
    A = parse_input(input)
    risk = 0
    for i in CartesianIndices(A)
        if is_lowpoint(A, i)
            risk += risk_level(A[i])
        end
    end
    return risk
end
@info part_1(input)

function adj_coords(A, p::CartesianIndex)
    return (p + a for a in neighbours() if checkbounds(Bool, A, p + a))
end

function basin_size(A, checked, p::CartesianIndex)
    fill!(checked, false)
    to_check = [p]
    bsize = 0
    while length(to_check) > 0
        pp = pop!(to_check)
        if !checked[pp] && A[pp] < 9
            bsize += 1
            for ppp in (pp + a for a in neighbours())
                if checkbounds(Bool, A, ppp) && !checked[ppp]
                    push!(to_check, ppp)
                end
            end
        end
        checked[pp] = true
    end
    return bsize
end

function part_2(input)
    A = parse_input(input)
    checked = Array{Bool}(undef, size(A))
    basins = Int[]
    for i in CartesianIndices(A)
        if is_lowpoint(A, i)
            push!(basins, basin_size(A, checked, i))
        end
    end    
    partialsort!(basins, 3, rev=true)
    return prod(first(basins, 3))
end
@info part_2(input)

@testset "December 9" begin
    @test part_1(testinput) == 15
    @test part_1(input) == 491

    @test part_2(testinput) == 1134
    @test part_2(input) == 1075536
end
nothing
