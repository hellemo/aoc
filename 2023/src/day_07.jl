# https://adventofcode.com/2023/day/7
using AdventOfCode
using StatsBase
using Test
using Base.Threads

input = "2023/data/day_07.txt"
testinput = "2023/data/test_07.txt"

abstract type AbstractHand end
struct Hand{S,N} <: AbstractHand
    cards::S
    bid::N
    score::N
end

struct SecondHand{S,N} <: AbstractHand
    cards::S
    bid::N
    score::N
end

@enum Hands HIGH ONE TWO THREE HOUSE FOUR FIVE

function parse_data(input, T)
    data = T[]
    collect(
        Iterators.flatten(
            fetch.(
                @spawn parse_line.(l, T) for l in Iterators.partition(eachline(input), 34)
            ),
        ),
    )
    return data
end

function parse_line(l, T)
    h, b = split(l)
    T(string(h), parse(Int, b), Int(hand_score(string(h), T)))
end

card_score(h::AbstractHand, c) = findfirst(h.cards[c], "AKQJT98765432")
card_score(h::SecondHand, c) = findfirst(h.cards[c], "AKQT98765432J")

function Base.isless(a::AbstractHand, b::AbstractHand)
    a.score < b.score && return true
    a.score > b.score && return false
    if a.score == b.score
        for c = 1:5
            card_score(b, c) < card_score(a, c) && return true
            card_score(b, c) > card_score(a, c) && return false
        end
    end
    return false
end

function hand_score(h, T::Type{Hand{S,N}}) where {S,N}
    ch = countmap(h)
    maxeq = maximum(values(ch))
    maxeq == 1 && return HIGH
    if maxeq == 2
        length(ch) == 3 && return TWO
        return ONE
    end
    if maxeq == 3
        length(ch) == 2 && return HOUSE
        return THREE
    end
    maxeq == 4 && return FOUR
    maxeq == 5 && return FIVE
end

function hand_score(h, T::Type{SecondHand{S,N}}) where {S,N}
    ch = countmap(h)
    jokers = get(ch, 'J', 0)
    jokers == 0 && return hand_score(h, Hand{S,N})
    maxeq = maximum(values(ch))
    if maxeq == 1
        jokers == 1 && return ONE
    end
    if maxeq == 2
        if length(ch) == 3  # Two pairs
            jokers == 1 && return HOUSE
            jokers == 2 && return FOUR
        else # One pair
            jokers == 2 && return THREE
            jokers == 1 && return THREE
        end
    end
    if maxeq == 3
        if length(ch) == 2
            jokers == 3 && return FIVE
            jokers == 2 && return FIVE
        end
        jokers == 3 && return FOUR
        jokers == 1 && return FOUR
    end
    if maxeq == 4
        jokers > 0 && return FIVE
    end
    maxeq == 5 && return FIVE
end

function part_1(input, T = Hand{String,Int})
    hands = parse_data(input, T)
    sort!(hands)
    return sum(i * v.bid for (i, v) in enumerate(hands))
end

@test part_1(testinput) == 6440
@test part_1(input) == 253954294
@info "Part1:" part_1(input)

function part_2(input)
    return part_1(input, SecondHand{String,Int})
end

@test part_2(testinput) == 5905
@test part_2(input) == 254837398
@info "Part2:" part_2(input)
