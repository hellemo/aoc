# https://adventofcode.com/2021/day/17
using AdventOfCode
using Test

input = readlines("2021/data/day_17.txt")
testinput = readlines("2021/data/day_17_test.txt")

function parse_input(input)
    v = split(input[1],[' ',',','.','='])
    i = parse.(Int, v[[0,0,0,1,0,1,0,0,1,0,1].>0])
    return([i[1],i[2]],[i[3],i[4]])
end

step(x, y, vx, vy) = x + vx, y +vy, vx - sign(vx), vy -1

function within_target(pos, target)
    x, y = pos
    tx, ty = target
    sort!(tx)
    sort!(ty)   
    return (tx[1] <= x <= tx[2]) && (ty[1] <= y <= ty[2])
end

function beyond_target(pos, target)
    x,y = pos
    tx,ty = target
    sort!(tx)
    sort!(ty)
    return (x > maximum(tx)) || (y < minimum(ty))
end

maxtarget(target) = maximum(abs.(target[1])), maximum(abs.(target[2]))

function naive_search(target)
    highest = 0
    MAXX, MAXY = maxtarget(target)
    for x = 1:MAXX, y = 1:MAXY
        highest = max(highest, simulate(x, y, target))
    end
    return highest
end

function simulate(vx0, vy0, target, N=1000)
    x = y = ymax = 0
    vx = vx0
    vy = vy0
    for _ in 1:N
        x, y, vx, vy = step(x, y, vx, vy)
        ymax = max(ymax, y)
        @debug "step:" x y vx vy
        within_target((x, y), target) && return ymax
        beyond_target((x, y), target) && return 0
    end
    return -1
end

function part_1(input)
    return naive_search(parse_input(input))
end
@info part_1(input)

function naive_search2(target)
    hits = []
    MAXX, MAXY = maxtarget(target)
    for x = 1:MAXX, y = -MAXY:MAXY
        m = simulate2(x, y, target)
        if m > 0
            push!(hits, (x, y))
        end
    end
    return length(unique(hits))
end

function simulate2(vx0, vy0, target, N=1000)
    x = y = 0
    vx = vx0
    vy = vy0
    for _ in 1:N
        x, y, vx, vy = step(x, y, vx, vy)
        @debug "step:" x y vx vy
        within_target((x,y), target) && return 1
        beyond_target((x,y), target) && return 0
    end
    return -1
end

function part_2(input)
    return naive_search2(parse_input(input))
end
@info part_2(input)

@testset "December 17" begin
    @test part_1(testinput) == 45
    @test part_1(input) == 11175
    
    @test part_2(testinput) == 112
    @test part_2(input) == 3540
end