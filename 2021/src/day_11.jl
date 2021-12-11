# https://adventofcode.com/2021/day/11
using AdventOfCode
using Test

input = readlines("2021/data/day_11.txt")
testinput = readlines("2021/data/day_11_test.txt")

function parse_input(input)
    N = length(input)
    M = length(first(input))
    A = Array{UInt8,2}(undef, N, M)
    for i = 1:N
        row = parse.(UInt8, (c for c in input[i]))
        for j = 1:M
            A[i, j] = row[j]
        end
    end
    return A
end

const NEIGHBOURS = let 
    setdiff((CartesianIndex(-1,-1):CartesianIndex(1,1)), (CartesianIndex(0,0), ))
end
neighbours() = NEIGHBOURS

function flash!(A, i::CartesianIndex, already_flashed)
    adj = neighbours()
    already_flashed[i] = true
    for n in (i+a for a in adj)  
        if checkbounds(Bool, A, n)
            A[n] += 1
        end
    end
    for n in (i+a for a in adj)
        if checkbounds(Bool, A, n) && !already_flashed[n] && A[n] > 9
            flash!(A, n, already_flashed)
        end
    end
    A[already_flashed] .= 0
end

function step!(A, already_flashed)
    A .+= 1
    fill!(already_flashed, false)
    for i in CartesianIndices(A)
        if !already_flashed[i] && A[i] > 9 # Flash
            flash!(A, i, already_flashed)
        end
    end
end

function part_1(input, N=100)
    A = parse_input(input)
    already = fill(false, size(A))
    flash_count = 0
    for _ = 1:N
        step!(A, already)
        flash_count += sum(A .== 0)
    end
    flash_count
end
@info part_1(input)

function part_2(input)
    A = parse_input(input)
    already = fill(false, size(A))
    step = 0
    while sum(A) > 0
        step!(A, already)
        step += 1
    end
    step
end
@info part_2(input)

@testset "December 11" begin
    @test part_1(testinput) == 1656
    @test part_1(input) == 1679

    @test part_2(testinput) == 195 
    @test part_2(input) == 519
end