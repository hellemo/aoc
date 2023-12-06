# https://adventofcode.com/2023/day/6
using AdventOfCode
using Test

input = "2023/data/day_06.txt"
testinput = "2023/data/test_06.txt"

function parse_data(input)
    f, l = eachline(input)
    time, distance = map(x -> parse.(Int, split(last(split(x, ":")))), (f, l))
    return time, distance
end

function solve(t, d)
    tmp = sqrt(t^2 - 4 * d)
    Int(ceil((-t - tmp) / (-2))) - Int(floor((-t + tmp) / (-2))) - 1
end

function part_1(input)
    time, distance = parse_data(input)
    prod(solve(t, distance[i]) for (i, t) in enumerate(time))
end

@test part_1(testinput) == 288
@test part_1(input) == 252000
@info "Part1:" part_1(input)

function parse_2(input)
    f, l = eachline(input)
    f = replace(f, " " => "")
    l = replace(l, " " => "")
    time, distance = map(x -> parse.(Int, split(last(split(x, ":")))), (f, l))
    return only(time), only(distance)
end

function part_2(input)
    t, d = parse_2(input)
    solve(t, d)
end

@test part_2(testinput) == 71503
@test part_2(input) == 36992486
@info "Part2:" part_2(input)
