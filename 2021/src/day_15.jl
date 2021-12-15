# https://adventofcode.com/2021/day/15
using AdventOfCode

input = readlines("2021/data/day_15.txt")
testinput = readlines("2021/data/day_15_test.txt")

function parse_input(input, T=UInt16)
    N = length(input)
    M = length(first(input))
    A = Array{T,2}(undef, N, M)
    for i = 1:N
        row = parse.(T, (c for c in input[i]))
        for j = 1:M
            A[i, j] = row[j]
        end
    end
    return A
end

function neighbours()
    [CartesianIndex( 0, -1),
     CartesianIndex(-1,  0),
     CartesianIndex( 1,  0),
     CartesianIndex( 0,  1),]
end

function color!(D, A, i)
    for n in neighbours()
        if checkbounds(Bool, D, i+n)
            if D[i+n]>D[i] + A[i+n]
                D[i+n] = D[i] + A[i+n]
            end
        end
    end
end

function distances(A)
    D = fill(typemax(eltype(A)),size(A))
    D[end] = 0
    ix = CartesianIndices(A)
    point = maximum(ix)
    to_visit = [point]
    visited = zeros(Bool, size(A))
    colored = zeros(Bool, size(A))
    p = maximum(ix)
    while p != first(ix)
        unique!(to_visit)
        p = pop!(to_visit)
        visited[p] = true
        colored[p] = false
        for n in neighbours()
            np = p+n
            if checkbounds(Bool, D, np) 
                if D[np]>D[p] + A[np]
                    D[np] = D[p] + A[np]
                    colored[np] = true
                end
                if !visited[np] && colored[np]
                    idx = findfirst(x->D[x]>D[np],to_visit)
                    if idx === nothing
                        push!(to_visit, np)
                    else
                        partialsort!(to_visit,idx;by=x->D[x],rev=true)
                        insert!(to_visit, idx, np)
                    end
                end
            end
        end
    end
    return D
end

using DataStructures
function distances2(A)
    D = fill(typemax(eltype(A)),size(A))
    D[end] = 0
    ix = CartesianIndices(A)
    p = maximum(ix)
    to_visit = PriorityQueue{CartesianIndex{2},eltype(D)}()
    to_visit[p] = 10
    visited = zeros(Bool, size(A))
    while p != first(ix)
        p = dequeue!(to_visit)
        visited[p] = true
        for n in neighbours()
            np = p+n
            if checkbounds(Bool, D, np) 
                if D[np]>D[p] + A[np]
                    D[np] = D[p] + A[np]
                end
                if !visited[np] 
                    to_visit[np] = D[np]
                end
            end
        end
    end
    return D
end

function part_1(input , distances=distances2)
    A = parse_input(input)
    D = distances(A)
    return D[begin] - A[begin] + A[end]
end
@info part_1(input)

function offset_tile(A, offset)
    C = copy(A)
    C .+= offset
    C[C.>9] .-= 9
    return C
end
ot(A,i) = offset_tile(A,i)

function part_2(input, distances=distances2)
    A = parse_input(input)
    LM = [ot(A,0) ot(A,1) ot(A,2) ot(A,3) ot(A,4)
          ot(A,1) ot(A,2) ot(A,3) ot(A,4) ot(A,5)
          ot(A,2) ot(A,3) ot(A,4) ot(A,5) ot(A,6)
          ot(A,3) ot(A,4) ot(A,5) ot(A,6) ot(A,7)
          ot(A,4) ot(A,5) ot(A,6) ot(A,7) ot(A,8)]
    D = distances(LM)
    return D[begin] - LM[begin] + LM[end]
end
@info part_2(input)

using Test
@testset "December 15" begin
    @test part_1(testinput) == 40
    @test part_1(input) == 415

    @test part_2(testinput, distances2) == 315
    @test part_2(input, distances2) == 2864 
end

function step(D, i)
    nextpoint = CartesianIndex(0,0)
    next = typemax(eltype(A)) 
    for n in neighbours()
        if checkbounds(Bool, D, i+n)
            if D[i+n] < next
                next = D[i+n]
                nextpoint = i+n
            end
        end
    end
    return nextpoint
end

function tracepath(A, D)
    path = zeros(Bool, size(A))
    point = CartesianIndex(1,1)
    path[point] = true
    while point != last(CartesianIndices(A))
        point = step(D, point)
        path[point] = true
    end
    return path
end