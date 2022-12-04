# https://adventofcode.com/2022/day/4
using AdventOfCode
using Test

input = "2022/data/day_04.txt"
testinput = "2022/data/test_04.txt"

contains(a, b) =
    length(intersect(a, b)) == length(a) || length(intersect(a, b)) == length(b)
overlaps(a, b) = length(intersect(range(first(a), last(a)), range(first(b), last(b)))) > 0

function solve(input, test = contains)
    c = 0
    for l in eachline(input)
        p = split(l, ",")
        a = range(parse.(Int, split(first(p), "-"))...)
        b = range(parse.(Int, split(last(p), "-"))...)
        if test(a, b)
            c = c + 1
        end
    end
    return c
end

function part_1(input)
    solve(input)
end

@test part_1(testinput) == 2
@test part_1(input) == 644
@info "Part1:" part_1(input)

function part_2(input)
    solve(input, overlaps)
end

@test part_2(testinput) == 4
@test part_2(input) == 926
@info "Part 2:" part_2(input)
