# https://adventofcode.com/2023/day/1
using AdventOfCode
using Test

input = "2023/data/day_01.txt"
testinput = "2023/data/test_01.txt"
testinput2 = "2023/data/test_01_2.txt"

function parse_data(input)
    for l in eachline(input)
        @info l
    end
end

function first_digit(l)
    for c in l
        isnumeric(c) && return parse(Int, c)
    end
end
last_digit(l) = first_digit(reverse(l))

function part_1(input)
    sum(first_digit(l) * 10 + last_digit(l) for l in eachline(input))
end

@test part_1(testinput) == 142
@test part_1(input) == 54667
@info "Part1:" part_1(input)

const D = Dict(
    "one" => 1,
    "two" => 2,
    "three" => 3,
    "four" => 4,
    "five" => 5,
    "six" => 6,
    "seven" => 7,
    "eight" => 8,
    "nine" => 9,
)
const revD = let
    tmp = Dict()
    for k in keys(D)
        tmp[reverse(k)] = D[k]
    end
    tmp
end

function first_digit(l, D)
    for i = 1:length(l)
        d = digit(l, i, D)
        if !isnothing(d)
            return d
        end
    end
end
last_digit(l, revD) = first_digit(reverse(l), revD)


function digit(l, pos, D)
    # If number, terminate early
    isnumeric(l[pos]) && return codepoint(l[pos]) - 48
    for extra = 1:4
        # Check if next position is characters
        if pos + extra <= length(l) && isletter(l[pos+extra])
            if extra > 1
                if haskey(D, l[pos:pos+extra])
                    return D[l[pos:pos+extra]]
                end
            end
        else
            return nothing
        end
    end
end

function part_2(input)
    sum(first_digit(l, D) * 10 + last_digit(l, revD) for l in eachline(input))
end

@test part_2(testinput2) == 281
@test part_2(input) == 54203
@info "Part2:" part_2(input)
