# https://adventofcode.com/2023/day/8
using AdventOfCode
using Base.Threads
using Test

input = "2023/data/day_08.txt"
testinput = "2023/data/test_08.txt"

function parse_data(input)
    instructions, rest = Iterators.peel(eachline(input))
    d = Dict{String,@NamedTuple{L::SubString{String}, R::SubString{String}}}()
    for l in rest
        if length(l) > 0
            A, L, R = parse_line(l)
            d[A] = (; L, R)
        end
    end
    return instructions, d
end

function parse_line(l)
    rx = r"(?<address>[A-Z]*) = \((?<L>[A-Z]*), (?<R>[A-Z]*)\)"
    m = match(rx, l)
    return Tuple(m.captures)
end

function solve(instructions, d, start = "AAA", stop = "ZZZ")
    location = start
    steps = 0
    while !endswith(location, stop)
        for c in instructions
            steps = steps + 1
            if c == 'L'
                location = first(d[location])
            else
                location = last(d[location])
            end
        end
    end
    return steps
end

function part_1(input)
    solve(parse_data(input)...)
end

@test part_1(testinput) == 2
@test part_1(input) == 19631
@info "Part1:" part_1(input)

function part_2(input)
    i, d = parse_data(input)
    return lcm(fetch.(@spawn solve(i,d,l,"Z") for l in filter(endswith("A"), keys(d))))
end

@test part_2(input) == 21003205388413
@info "Part2:" part_2(input)
