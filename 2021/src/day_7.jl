# https://adventofcode.com/2021/day/7
using AdventOfCode
using Test

input = readlines("2021/data/day_7.txt")
testinput = readlines("2021/data/day_7_test.txt")

parse_input(input) = parse.(Int,split(first(input),","))

function crab_costs(positions, fuelcost=identity)
    N = length(positions)
    A = fill(N,N,N)
    for i = 1:N
        @views A[i,:] .= fuelcost.(abs.(i .- positions))
    end
    cost = sum(A, dims=2)
    return findmin(cost)[1]
end

function part_1(input)
    positions = parse_input(input)
    crab_costs(positions)
end
@info part_1(input)

fuel(x) = sum(1:x)
function part_2(input)
    positions = parse_input(input)
    return crab_costs(positions, fuel)
end
@info part_2(input)

@testset "December 7" begin
    @test part_1(testinput) == 37
    @test part_1(input) == 336040

    @test part_2(testinput) == 168
    @test part_2(input) == 94813675
end
nothing