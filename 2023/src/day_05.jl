# https://adventofcode.com/2023/day/5
using AdventOfCode
using Test

using Base.Threads

input = "2023/data/day_05.txt"
testinput = "2023/data/test_05.txt"

function parse_data(input)
    tmp = []
    for l in split(read(input, String), "\n\n")
        t, v = parse_line(l)
        push!(tmp, t => v)
    end
    return only(last(first(tmp))), last.(tmp[2:end])
end

function parse_line(l)
    t, v = split(l, ":")
    if t == "seeds"
        nothing
    else
        t = first(split(t))
    end
    v = [parse.(Int, split(i)) for i in split(v, "\n") if length(i) > 0]
    if t != "seeds"
        v = [[range(i[1], length = i[3]), range(i[2], length = i[3])] for i in v]
        t = split(t, "-")
    end
    return t, v
end

function transition(n, ranges)
    for r in ranges
        to, from = r
        if n in from
            return translaterange(n, from, to)
        end
    end
    return n
end

function solve_seed(seed, list)
    dest = seed
    for ranges in list
        for r in ranges
            to, from = r
            if dest in from
                dest = translaterange(dest, from, to)
                break
            end
        end
    end
    return dest
end

function solve(seeds, list)
    minseed = typemax(Int)
    for s in seeds
        cand = solve_seed(s, list)
        if cand < minseed
            minseed = cand
        end
    end
    return minseed
end

function translaterange(n, fromrange, torange)
    !in(n, fromrange) && return n
    offset = n - first(fromrange)
    return first(torange) + offset
end

# function translaterange(n::UnitRange, fromrange, torange)
#     return range(translaterange(first(n), fromrange, torange),translaterange(last(n), fromrange, torange))
# end

function part_1(input)
    seeds, list = parse_data(input)
    minimum(solve(es, list) for es in seeds)
end

@test part_1(testinput) == 35
@test part_1(input) == 173706076
@info "Part1:" part_1(input)

function expandseeds(seeds)
    return [range(first(i), length = last(i)) for i in Iterators.partition(seeds, 2)]
end

function part_2(input)
    seeds, list = parse_data(input)
    minimum(fetch.(@spawn solve(es, list) for es in expandseeds(seeds)))
end

@test part_2(testinput) == 46
res_part_2 = part_2(input)
@test res_part_2 == 11611182
@info "Part2:" res_part_2 
