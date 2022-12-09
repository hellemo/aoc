# https://adventofcode.com/2022/day/9
using AdventOfCode
using Test

input = "2022/data/day_09.txt"
testinput = "2022/data/test_09.txt"
testinput2 = "2022/data/test_09_2.txt"

function move_head(dir, len, head, tail, umoves)
    new_head = head
    new_tail = tail
    for l = 1:len
        new_head = step(dir, new_head)
        new_tail = move_tail(new_head, new_tail)
        umoves[new_tail] = true
    end
    return new_head, new_tail
end

m(d) = abs(d) > 0 ? sign(d) : 0

function move_tail(head, tail)
    x = first(tail)
    y = last(tail)
    diff = head .- tail

    ΔX = first(diff)
    ΔY = last(diff)
    # 1) Two steps directly up/down/r/l
    #    move one step in that dir
    abs(ΔX) > 1 && ΔY == 0 && return (x + m(ΔX), y)
    abs(ΔY) > 1 && ΔX == 0 && return (x, y + m(ΔY))

    # 2) Not touching and not same row/col
    if ΔX == 0 || ΔY == 0 || (abs(ΔX) == abs(ΔY) && abs(ΔY) == 1)
        return tail
    else
        return (x + m(ΔX), y + m(ΔY))
    end
end

function step(dir, pos)
    x = first(pos)
    y = last(pos)
    dir == "L" && return (x - 1, y)
    dir == "U" && return (x, y + 1)
    dir == "R" && return (x + 1, y)
    dir == "D" && return (x, y - 1)
end

function part_1(input)
    h = (0, 0)
    t = (0, 0)
    umoves = Dict{Tuple{Int,Int},Bool}()
    for l in eachline(input)
        dir, len_s = split(l)
        len = parse(Int, len_s)
        h, t = move_head(dir, len, h, t, umoves)
    end
    return length(umoves)
end

@test part_1(testinput) == 13
@test part_1(input) == 6745
@info "Part1:" part_1(input)

function part_2(input)
    rope = [(0, 0) for _ = 1:10]
    umoves = Dict{Tuple{Int,Int},Bool}()
    for l in eachline(input)
        dir, len_s = split(l)
        len = parse(Int, len_s)
        for l = 1:len
            rope[1] = step(dir, rope[1])
            for t = 2:length(rope)
                rope[t] = move_tail(rope[t-1], rope[t])
            end
            umoves[rope[end]] = true
        end
    end
    return length(umoves)
end

@test part_2(testinput) == 1
@test part_2(testinput2) == 36
@test part_2(input) == 2793
@info "Part2:" part_2(input)

# For debugging:
function showpath(visited)
    ks = (CartesianIndex(k) for k in keys(visited))
    ll, ur = extrema(ks)
    I = CartesianIndices((first(ll.I):first(ur.I), last(ll.I):last(ur.I)))
    for j in reverse(last(ll.I):last(ur.I))
        for i in (first(ll.I):first(ur.I))
            print(haskey(visited, (i, j)) ? "#" : ".")
        end
        println()
    end
end

function showstate(snake)
    ks = (CartesianIndex(k) for k in snake)
    ll, ur = extrema(ks)
    z = Dict(zip(copy(rope), [i - 1 for i = 1:length(rope)]))
    for j in reverse(last(ll.I):last(ur.I))
        for i in (first(ll.I):first(ur.I))
            haskey(z, (i, j)) ? print(z[(i, j)]) : print(".")
        end
        println()
    end
end
