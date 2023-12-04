# https://adventofcode.com/2023/day/4
using AdventOfCode
using Test
using Base.Threads: @spawn

input = "2023/data/day_04.txt"
testinput = "2023/data/test_04.txt"

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

function solve(matches::Vector{Int})
    cards = ones(Int, length(matches))
    for card = 1:length(cards)
        cards[card+1:card+matches[card]] .+= cards[card]
    end
    return sum(cards)
end

function both_parts(input, N = 13)
    n_lines = Iterators.partition(enumerate(eachline(input)), N)
    res = fetch.(@spawn map.(x->first(x)=>matches_line(last(x)),[x]) for x in n_lines)
    matches = last.(only(sort(vcat.(res...); by = x -> first(x))))
    return sum(x > 0 ? 2^(x - 1) : 0 for x in matches), solve(matches)
end

@test both_parts(testinput) == (13, 30)
@test both_parts(input) == (23750, 13261850)
