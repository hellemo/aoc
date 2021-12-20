# https://adventofcode.com/2021/day/20
using AdventOfCode
using LinearAlgebra
using Test

input = readlines("2021/data/day_20.txt")
testinput = readlines("2021/data/day_20_test.txt")

function parse_input(input)
    algorithm = [c == '#' for c in input[1]]
    image_txt = input[3:end]
    N = length(image_txt)
    M = length(image_txt[1])
    image = zeros(Bool, M,N)
    for (i,l) in enumerate(image_txt)
        for j in 1:N
            image[i,j] = l[j] == '#'
        end
    end
    algorithm, image
end

function neighbours() 
    [CartesianIndex(-1, -1),
     CartesianIndex(-1, 0),
     CartesianIndex(-1, 1),
     CartesianIndex(0, -1),
     CartesianIndex(0, 0),
     CartesianIndex(0, 1),
     CartesianIndex(1, -1),
     CartesianIndex(1, 0),
     CartesianIndex(1, 1),]
end

function ci_to_dec(A, ci, outside=false)
    v = Vector{Bool}(undef, 9)
    for (i,n) in enumerate(neighbours())
        if checkbounds(Bool, A, ci + n)
            v[i] = A[ci + n]
        else
            v[i] = outside
        end
    end
    return bin2int(v)
end

struct Dim{N} end
bin2int(v) = bin2int(v,Dim{length(v)}())
@generated function bin2int(v, ::Dim{N}) where {N}
    w = reverse([2^(i-1) for i in 1:N])
    :(dot($w,v))
end

function part_1(input, N=2, final=sum)
    algo, A = parse_input(input)
    def = false
    for _ = 1:N
        B = zeros(Bool, size(A).+2)
        for ci in CartesianIndices(B)
            B[ci] = algo[ci_to_dec(A, ci - CartesianIndex(1,1), def) + 1]
        end
        def = algo[bin2int(repeat([def],9))+1]
        A = B
    end
    return final(A)
end
@info part_1(input)

function part_2(input)
    part_1(input, 50)
end
@info part_2(input)

@testset "December 20" begin
    @test part_1(testinput) == 35
    @test part_1(input) == 5301

    @test part_2(testinput) == 3351
    @test part_2(input) == 19492
end

function print_img(A)
    for i in 1: size(A,1)
        for j in 1:size(A,2)
            print(A[i,j] ? '#' : '.')
        end
        println()
    end
end
