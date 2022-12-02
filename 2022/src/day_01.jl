# https://adventofcode.com/2022/day/1
using AdventOfCode
using Test

input = read("2022/data/day_01.txt", String)
testinput = read("2022/data/test_01.txt", String)

function parse_data_short(input)
    [
        mapreduce(x -> parse(Int, x), +, split(i, "\n")) for
        i in eachsplit(chomp(input), "\n\n")
    ]
end

function parse_data(input)
    elves = Int[]
    thiselve = 0
    prevn = false
    for l in eachsplit(input, "\n")
        if length(l) > 0
            calories = parse(Int, l)
            if !prevn # new elve
                prevn = true
                thiselve = thiselve + 1
                push!(elves, calories)
            else # add to this elve
                elves[thiselve] += calories
            end
        else # new elve
            prevn = false
        end
    end
    return elves
end

function part_1(input, p = parse_data)
    maximum(p(input))
end
@test part_1(testinput) == 24000
@test part_1(input) == 70698
@info "Part 1: " part_1(input)

function part_2(input, p = parse_data)
    sum(partialsort!(p(input), 1:3; rev = true))
end
@test part_2(testinput) == 45000
@test part_2(input) == 206643
@info "Part 2: " part_2(input)
