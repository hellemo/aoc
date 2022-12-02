# https://adventofcode.com/2022/day/2
using AdventOfCode
using Test

input = "2022/data/day_02.txt"
testinput = "2022/data/test_02.txt"

abstract type Shape end
struct Rock <: Shape end
struct Scissors <: Shape end
struct Paper <: Shape end

function decode_opponent(c::Char) 
    c == 'A' && return Rock()
    c == 'B' && return Paper()
    c == 'C' && return Scissors()
end

function decode_mymove(c::Char)
    c == 'X' && return Rock()
    c == 'Y' && return Paper()
    c == 'Z' && return Scissors()
end

abstract type Result end
struct Win <: Result end
struct Draw <: Result end
struct Loss <: Result end

function decode_desired_result(c::Char)
    c == 'X' && return Loss()
    c == 'Y' && return Draw()
    c == 'Z' && return Win()
end

abstract type Day2 end
struct Rule1<:Day2 end
struct Rule2<:Day2 end
decode_instructions(s, ::Rule1) = decode_opponent(first(s)), decode_mymove(last(s)) 
decode_instructions(s, ::Rule2) = decode_opponent(first(s)), decode_desired_result(last(s)) 

result(::Rock, ::Scissors) = Loss()
result(::Scissors, ::Paper) = Loss()
result(::Paper, ::Rock) = Loss()
result(::T,::T) where {T<:Shape} = Draw()
result(::Shape, ::Shape) = Win()

points(::Rock) = 1
points(::Paper) = 2
points(::Scissors) = 3
points(::Win) = 6
points(::Draw) = 3
points(::Loss) = 0

my_move(::Rock, ::Loss) = Scissors()
my_move(::Scissors, ::Loss) = Paper()
my_move(::Paper, ::Loss) = Rock()
my_move(opponent::Shape, ::Draw) = opponent
my_move(::Rock, ::Win) = Paper()
my_move(::Scissors, ::Win) = Rock()
my_move(::Paper, ::Win) = Scissors()

score(opponent::Shape, mymove::Shape) = points(mymove) + points(result(opponent, mymove))
score(opponent::Shape, desired::Result) = score(opponent, my_move(opponent, desired))

function solve(input, rule::Day2) 
    epoints = 0
    for l in eachline(input)
        epoints = epoints + score(decode_instructions(l, rule)...)
    end
    return epoints
end
# Shorter, but slower
solve_short(input, rule::Day2) = sum(score(decode_instructions(l, rule)...) for l in eachline(input))

function part_1(input, s = solve)
    s(input, Rule1())
end

@test part_1(testinput) == 15
@test part_1(input) == 11666
@info "Part 1: " part_1(input)

function part_2(input, s = solve)
    s(input, Rule2())
end

@test part_2(testinput) == 12
@test part_2(input) == 12767
@info "Part 2: " part_2(input)
