# https://adventofcode.com/2021/day/6
using AdventOfCode
using Test

input = readlines("2021/data/day_6.txt")
testinput = readlines("2021/data/day_6_test.txt")

function parse_input(input)
    return parse.(Int,split(input[1],","))
end

function part_2(input, N=256)
    incoming = parse_input(input)
    🐟 = zeros(Int,9)
    for i in incoming
        🐟[i+1] +=1
    end
    🦈 = zeros(Int, size(🐟))
    @inbounds for _ = 1:N
        @views 🦈[end] = 🐟[1]
        @views 🦈[1:end-1] = 🐟[2:end]
        @views 🦈[end-2] = 🦈[end-2] + 🐟[1]
        🐟 .= 🦈
    end
    return sum(🐟)
end

part_1(input, N=80) = part_2(input, N)

@info part_1(input)
@info part_2(input)

@testset "December 6" begin
    @test part_1(testinput) == 5934
    @test part_1(input) == 362639

    @test part_2(testinput) == 26984457539
    @test part_2(input) == 1639854996917
end


# Over-engineered solution based on Zulip discussion
# https://julialang.zulipchat.com/#narrow/stream/307139-advent-of-code-.282021.29/topic/day.206
# https://julialang.zulipchat.com/#narrow/stream/307174-advent-of-code-spoilers-.282021.29/topic/Extreme.20speed.20day.206
using LinearAlgebra
using StaticArrays

struct Day{N} end
function over_engineered(fish,N=80) 
    x = MVector(0,0,0,0,0,0,0,0,0)
    for f in fish
        x[f + 1] += 1
    end
    over_engineered(x,Day{N}())
end
@generated function over_engineered(fish_counts,::Day{N}) where N
    coefs = sum([0  0  0  0  0  0  1  0  1
                 1  0  0  0  0  0  0  0  0
                 0  1  0  0  0  0  0  0  0
                 0  0  1  0  0  0  0  0  0
                 0  0  0  1  0  0  0  0  0
                 0  0  0  0  1  0  0  0  0
                 0  0  0  0  0  1  0  0  0
                 0  0  0  0  0  0  1  0  0
                 0  0  0  0  0  0  0  1  0]^N, dims=2)
    :(dot($coefs,fish_counts))
end

function too_optimized(input, N=80)
    fish = parse.(Int,split(input[1],","))
    over_engineered(fish, N)
end

@testset "Optimized" begin
    @test too_optimized(testinput) == 5934
    @test too_optimized(input) == 362639

    @test too_optimized(testinput, 256) == 26984457539
    @test too_optimized(input, 256) == 1639854996917
end
nothing