# https://adventofcode.com/2022/day/5
using AdventOfCode
using Test

input = "2022/data/day_05.txt"
testinput = "2022/data/test_05.txt"

function parse_data(input)
    stacks, instructions = split(read(input, String), "\n\n")
    moves = []
    for l in eachsplit(instructions, "\n")
        if length(l) > 0
            count, from, to = parse.(Int, match(r"move (\d+) from (\d+) to (\d+)", l))
            push!(moves, (count = count, from = from, to = to))
        end
    end

    S = reverse(split(stacks, "\n"))
    IDX = popfirst!(S)
    N = maximum(parse.(Int, split(IDX)))
    cstacks = [Char[] for i = 1:N]
    for l in S
        cpos = isuppercase.(collect(l))
        cs = collect(l)[cpos]
        ps = parse.(Int, collect(IDX)[cpos])
        for (i, c) in enumerate(cs)
            push!(cstacks[ps[i]], c)
        end
    end
    return cstacks, moves
end

function solve(stacks, instructions)
    for i in instructions
        for c = 1:i.count
            tmp = pop!(stacks[i.from])
            push!(stacks[i.to], tmp)
        end
    end
    return join(collect(pop!(s) for s in stacks))
end

function solve2(stacks, instructions)
    for i in instructions
        tmp = Char[]
        for c = 1:i.count
            push!(tmp, pop!(stacks[i.from]))
        end
        push!(stacks[i.to], reverse(tmp)...)
    end
    return join(collect(pop!(s) for s in stacks))
end

function part_1(input)
    s, i = parse_data(input)
    solve(s, i)
end

@test part_1(testinput) == "CMZ"
@test part_1(input) == "BZLVHBWQF"
@info "Part1:" part_1(input)

function part_2(input)
    s, i = parse_data(input)
    solve2(s, i)
end

@test part_2(testinput) == "MCD"
@test part_2(input) == "TDGJQTZSL"
@info "Part2:" part_2(input)
