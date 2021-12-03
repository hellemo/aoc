# https://adventofcode.com/2021/day/1
using AdventOfCode
using Test

input = parse.(Int,readlines("2021/data/day_1.txt"))

function part_1(input)
    count = 0
    prev = 0
    for i in input
        if i > prev
            count += 1
        end
        prev = i
    end
    return count
end
@info part_1(input)
# Allocating...
part_1b(input) = sum(input[2:end] .>= input[1:end-1]) + 1

# No time to complete recursive version
# function part_1c(input, prev, this,count=0)
#     (a, rest) = Iterators.peel(input)
#     part_1c(rest, this, a, this>prev ? count+1 : count)
# end


function part_2(input)
    window_sums = (sum(view(input,i-2:i)) for i in 3:length(input))
    return part_1(window_sums) - 1
end
@info part_2(input)

@testset "December 1" begin
    @test part_1(input) == 1343
    @test part_2(input) == 1378
end
nothing