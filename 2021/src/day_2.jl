# https://adventofcode.com/2021/day/2
using AdventOfCode
using Test

input = readlines("2021/data/day_2.txt")

testdata = readlines("2021/data/day_2_test.txt")

struct Down end
struct Forward end
struct Up end
move(x, y, dir::Down, len) = (x, y + len)
move(x, y, dir::Up, len) = (x, y - len)
move(x, y, dir::Forward, len) = (x + len, y)

function part_1(input)
    x = 0
    y = 0
    dirs = Dict("down" => Down(), "up" => Up(), "forward" => Forward())
    instr = split.(input)
    N = length(instr)
    for k in 1:N
        x,y = move(x,y, dirs[instr[k][1]],parse(Int,instr[k][2]))
    end
 
    return x * y
end
@info part_1(input)

move(x, y, aim, dir::Down, len) = (x, y , aim + len)
move(x, y, aim, dir::Up, len) = (x, y, aim -len)
move(x, y, aim, dir::Forward, len) = (x + len, y + aim * len, aim)

function part_2(input)
    x = 0
    y = 0
    aim = 0
    instr = split.(input)
    N = length(instr)
    dirs = Dict("down" => Down(), "up" => Up(), "forward" => Forward())
    
    for k in 1:N
        x, y, aim = move(x, y, aim, dirs[instr[k][1]], parse(Int,instr[k][2]))
    end
    return x * y
end
@info part_2(input)

@testset "December 2" begin
    @test part_1(input) == 1250395
    @test part_2(input) == 1451210346
end
nothing