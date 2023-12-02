# https://adventofcode.com/2023/day/2
using AdventOfCode
using Test

input = "2023/data/day_02.txt"
testinput = "2023/data/test_02.txt"

using Base.Threads: nthreads, @spawn
function tmapreduce(f, op, itr; tasks_per_thread::Int = 2, kwargs...)
    chunk_size = max(1, length(itr) ÷ (tasks_per_thread * nthreads()))
    tasks = map(Iterators.partition(itr, chunk_size)) do chunk
        @spawn mapreduce(f, op, chunk; kwargs...)
    end
    mapreduce(fetch, op, tasks; kwargs...)
end

function parse_line(p)
    i = first(p)
    l = last(p)
    game_num, games = split(l, ":")
    games = split(games, ";")
    all(isvalid.(parse_game.(games))) && return i
end

function part_1(input)
    tmapreduce(parse_line, +, collect(enumerate(eachline(input))))
end


function parse_game(g)
    rawcubes = split(g, ",")
    return [parse_draw(d) for d in rawcubes]
end

function isvalid(game, red = 12, green = 13, blue = 14)
    for g in game
        g.color == "red" && g.number > red && return false
        g.color == "green" && g.number > green && return false
        g.color == "blue" && g.number > blue && return false
    end
    return true
end

function parse_draw(d)
    tmp = split(d)
    return (color = last(tmp), number = parse(Int, replace(first(tmp), " " => "")))
end

@test part_1(testinput) == 8
@test part_1(input) == 2545
@info "Part1:" part_1(input)

function power(games)
    max_red = 0
    max_green = 0
    max_blue = 0
    for game in games
        for g in game
            if g.color == "red" && g.number > max_red
                max_red = g.number
            elseif g.color == "green" && g.number > max_green
                max_green = g.number
            elseif g.color == "blue" && g.number > max_blue
                max_blue = g.number
            end
        end
    end
    return max_red * max_green * max_blue
end

function parse_line2(l)
    game_num, games = split(l, ":")
    games = split(games, ";")
    power(parse_game.(games))
end

function part_2(input)
    tmapreduce(parse_line2, +, collect(eachline(input)))
end

@test part_2(testinput) == 2286
@test part_2(input) == 78111
@info "Part2:" part_2(input)
