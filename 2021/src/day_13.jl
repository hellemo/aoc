# https://adventofcode.com/2021/day/13
using AdventOfCode
using SparseArrays
using Test

input = readlines("2021/data/day_13.txt")
testinput = readlines("2021/data/day_13_test.txt")

abstract type Fold end
struct X<:Fold
    n::Int
end
struct Y<:Fold
    n::Int
end

function fold!(A, y::Y)
    top =    view(A, 1 : y.n, :)
    bottom = view(A, y.n+2:size(A,1), :)
    top .= top .| reverse!(bottom, dims=1)
end

function fold!(A, x::X)
    left =  view(A, :, 1:x.n)
    right = view(A, :, x.n + 2 : size(A,2))
    left .= left .| reverse!(right, dims=2)
end

function parse_input(input)
    coords = Array{CartesianIndex{2},1}()
    sizehint!(coords, length(input))
    folds = Vector{Fold}()
    iscoords = true
    for l in input
        if isempty(l)      
            iscoords = false
            continue
        elseif iscoords    
            s1, s2 = parse.(Int, split(l, ",")) .+ 1
            push!(coords, CartesianIndex(s2, s1))
        else               
            m = match(r"fold along (?<axis>\w)=(?<val>\d+)", l)
            if m[:axis] == "x"
                push!(folds, X(parse(Int, m[:val])))
            else #if m[:axis] == "y"
                push!(folds, Y(parse(Int, m[:val])))
            end
        end
    end
    N, M = maximum(coords).I
    A = zeros(Bool, N, M)
    @views A[coords] .= true
    return A, folds
end

function part_2(input, N=length(input))
    A, folds = parse_input(input)
    for f in first(folds, N)
        A = fold!(A, f)
    end
    A
end

function part_1(input)
    sum(part_2(input, 1))
end

@info part_1(input)
@info part_2(input)

@testset "December 13" begin
    @test part_1(testinput) == 17
    @test part_1(input) == 671

    @test sum(part_2(testinput, 1)) == 17
    @test sum(part_2(testinput, 2)) == 16
    @test sum(part_2(input)) == 97
end