# https://adventofcode.com/2021/day/5
using AdventOfCode
using Test

input = readlines("2021/data/day_5.txt")
testinput = readlines("2021/data/day_5_test.txt")

function parse_input(input)
    coords = Vector{Int}[]
    for l in input
        m = match(r"(\d+),(\d+) -> (\d+),(\d+)", l)
        push!(coords, [parse(Int, m[i]) + 1 for i=1:4])
    end
    return coords 
end

# Doesn't seem to be worth the effort
function parse_input2(input)
    coords = Array{Int16,2}(undef,length(input), 4)
    for (i,l) in enumerate(input)
        m = match(r"(\d+),(\d+) -> (\d+),(\d+)",l)
        for j = 1:4
            coords[i,j] = parse(Int16, m[j]) + 1
        end
    end
    return coords 
end

function horiz_or_vert(input,T)
    coords = parse_input(input)
    MAX = maximum(maximum.(coords)) + 1 # include 0
    lmap = zeros(T, MAX, MAX)

    for c in coords
        (x1, y1, x2, y2) = c
        if x2 < x1
            x1, x2 = x2, x1
        end
        if y2 < y1
            y1, y2 = y2, y1
        end
        if x1 == x2 || y1 == y2
            view(lmap, x1:x2, y1:y2) .+= 1
        end
    end
    return coords, lmap
end

function part_1(input)
    T = length(input) < typemax(Int16) ? Int16 : Int
    _, lmap = horiz_or_vert(input,T)
    return sum(lmap.>1)
end
@info part_1(input)

function diagonals(coords,A)
    for c in coords
        x1, y1, x2, y2 = c
        Δ = abs(x2 - x1)
        if Δ == abs(y2 - y1)
            sx = sign(x2 - x1)
            sy = sign(y2 - y1)
            for δ = 0:Δ
                A[x1 + δ * sx, y1 + δ * sy] += 1
            end
        end
    end
    return A
end

function part_2(input)
    T = length(input) < typemax(Int16) ? Int16 : Int
    coords, A = horiz_or_vert(input,T)
    lmap = diagonals(coords,A)
    return sum(lmap.>1)
end
@info part_2(input)

@testset "December 5" begin
    @test part_1(testinput) == 5
    @test part_1(input) == 7674

    @test part_2(testinput) == 12
    @test part_2(input) == 20898
end