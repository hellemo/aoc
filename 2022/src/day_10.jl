# https://adventofcode.com/2022/day/10
using AdventOfCode
using Test

input = "2022/data/day_10.txt"
testinput = "2022/data/test_10.txt"

function parse_data(input)
    reg = 1
    tick = 0
    regs = [1]
    for l in eachline(input)
        s = split(l)
        if length(s) == 2
            instr, val = s
            av = parse(Int, val)
            push!(regs, last(regs))
            push!(regs, last(regs) + av)
        else
            instr = first(s)
            push!(regs, last(regs))
        end
    end
    return regs
end

function signal(register)
    sig = Int[]
    for (i, v) in pairs(register)
        if i % 20 == 0
            push!(sig, v * i)
        end
    end
    return sig
end

function part_1(input)
    sum(signal(parse_data(input))[[1, 3, 5, 7, 9, 11]])
end

@test part_1(testinput) == 13140
@test part_1(input) == 14860
@info "Part1:" part_1(input)

function part_2(input)
    regs_ticks = parse_data(input)
    for (tick, reg) in pairs(regs_ticks)
        px = tick % 40
        sprite = (reg, reg + 1, reg + 2) # 0-indexed
        if px in sprite
            print("#")
        else
            print(".")
        end
        if px == 0
            println()
        end
    end
end

# @test part_2(testinput) == 1
# @test part_2(input) == 1
part_2(input)
