# https://adventofcode.com/2022/day/6
using AdventOfCode
using Test

input = "2022/data/day_06.txt"
testinput = "2022/data/test_06.txt"

function solve(input, N=4)
    for l in eachline(input)
        for c in 1:length(l) - N
            if length(unique(l[c:c+N-1])) == N
                return c + N - 1
            end
        end
    end
end

function part_1(input)
    solve(input, 4)
end

@test part_1(testinput) == 7
@test part_1(input) == 1804
@info "Part1:" part_1(input)    

function part_2(input)
    solve(input, 14)
end

@test part_2(testinput) == 19
@test part_2(input) == 2508
@info "Part2:" part_2(input) 

