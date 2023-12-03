# https://adventofcode.com/2023/day/4
using AdventOfCode
using Test

input = "2023/data/day_04.txt"
testinput = "2023/data/test_04.txt"

function parse_data(input)
    for l in eachline(input)
        @info l
    end
end

function parse_line(l)
    _, nums = split(l, ":")
    rawwinning, rawmine = split(nums, "|")
    winning = parse.(Int, split(rawwinning))
    mine = parse.(Int, split(rawmine))
    return winning, mine
end

function matches_line(l)
    winning, mine = parse_line(l)
    return length(findall(x -> in(x, winning), mine))
end

function score_line(l)
    N = matches_line(l)
    N > 0 && return 2^(N - 1)
    return 0
end

function part_1(input)
    return sum(score_line.(eachline(input)))
end

@test part_1(testinput) == 13
@test part_1(input) == 23750
@info "Part1:" part_1(input)

function solve(lines)
    cards = ones(Int, length(lines))
    for card = 1:length(cards)
        N = matches_line(lines[card])
        cards[card+1:card+N] .+= cards[card]
    end
    return sum(cards)
end

function part_2(input)
    solve(collect(eachline(input)))
end

@test part_2(testinput) == 30
@test part_2(input) == 13261850
@info "Part2:" part_2(input)
