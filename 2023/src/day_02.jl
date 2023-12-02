# https://adventofcode.com/2023/day/2
using AdventOfCode
using Test

input = "2023/data/day_02.txt"
testinput = "2023/data/test_02.txt"

function parse_data(input)
    gs = []
    for (i, l) in enumerate(eachline(input))
        game_num, games = split(l, ":")
        games = split(games, ";")
        push!(gs, [parse_game(g) for g in games])
    end
    return gs
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

function part_1(input)
    games = parse_data(input)
    score = 0
    for (i, g) in enumerate(games)
        if sum(isvalid.(g)) == length(g)
            score = score + i
        end
    end
    return score
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

function part_2(input)
    games = parse_data(input)
    return sum(power(g) for g in games)
end

@test part_2(testinput) == 2286
@test part_2(input) == 78111
@info "Part2:" part_2(input)
