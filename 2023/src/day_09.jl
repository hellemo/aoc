# https://adventofcode.com/2023/day/9
using AdventOfCode
using Base.Threads
using Test

input = "2023/data/day_09.txt"
testinput = "2023/data/test_09.txt"

function next_line(l)
    next_value(parse.(Int, split(l)))
end

function previous_line(l)
    next_value(reverse(parse.(Int, split(l))))
end

function next_value(ns)
    N = length(ns)
    while !all(isequal.(0, ns[1:N]))
        for n = 1:N-1
            ns[n] = ns[n+1] - ns[n]
        end
        N = N - 1
    end
    placeholder = 0
    while N <= length(ns)
        placeholder = placeholder + ns[N-1]
        N = N + 1
    end
    return placeholder + last(ns)
end

function part_1_serial(input, solve = next_line)
    sum(solve.(eachline(input)))
end

function part_1(input, solve = next_line, N = 2)
    sum(
        Iterators.flatten(
            fetch.(@spawn solve.(ls) for ls in Iterators.partition(eachline(input), N)),
        ),
    )
end

@test part_1(testinput) == 114
@test part_1(input) == 1479011877
@info "Part1:" part_1(input)

function part_2(input, N = 2)
    part_1(input, previous_line, N)
end

@test part_2(testinput) == 2
@test part_2(input) == 973
@info "Part2:" part_2(input)
