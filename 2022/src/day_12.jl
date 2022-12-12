# https://adventofcode.com/2022/day/12
using AdventOfCode
using DataStructures
using Test

input = "2022/data/day_12.txt"
testinput = "2022/data/test_12.txt"

function parse_data(input)
    D = split(chomp(read(input, String)), "\n")
    M = length(D)
    N = length(first(D))
    T = Int
    A = Array{T}(undef, M, N)
    S = CartesianIndex(0, 0)
    E = CartesianIndex(0, 0)
    for i = 1:M, j = 1:N
        A[i, j] = T(codepoint(D[i][j])) - T(codepoint('a'))
        if D[i][j] == 'S'
            S = CartesianIndex(i, j)
        elseif D[i][j] == 'E'
            E = CartesianIndex(i, j)
        end
    end
    return A, S, E
end

function neighbours()
    [
        CartesianIndex(0, -1),
        CartesianIndex(-1, 0),
        CartesianIndex(1, 0),
        CartesianIndex(0, 1),
    ]
end

function legal_moves(A, p::CartesianIndex)
    return (
        p + a for a in neighbours() if checkbounds(Bool, A, p + a) && (A[p+a] - A[p] < 2)
    )
end

distances(A, S, E) = distances!(fill(typemax(eltype(A)), size(A)), A, S, E)
function distances!(D, A, S, E)
    D[S] = 0
    A[S] = 0
    A[E] = 26
    p = S
    to_visit = PriorityQueue{CartesianIndex{2},eltype(D)}()
    to_visit[p] = 0
    visited = zeros(Bool, size(A))
    while p != E
        if isempty(to_visit)
            return fill!(D, length(A) + 1)
        else
            p = dequeue!(to_visit)
            visited[p] = true
            for n in legal_moves(A, p)
                if (D[n] > D[p] + 1)
                    D[n] = D[p] + 1
                end
                if !visited[n]
                    to_visit[n] = D[n]
                end
            end
        end
    end
    return D
end

solve(A, S, E) = solve!(fill(typemax(eltype(A)), size(A)), A, S, E)
function solve!(D, A, S, E)
    distances!(D, A, S, E)
    return D[E]
end

function part_1(input)
    A, S, E = parse_data(input)
    solve(A, S, E)
end

@test part_1(testinput) == 31
@test part_1(input) == 361
@info "Part1:" part_1(input)

function part_2(input)
    A, S, E = parse_data(input)
    D = length(A)
    DM = fill(typemax(eltype(A)), size(A))
    for ix in CartesianIndices(A)
        fill!(DM, typemax(eltype(A)))
        if A[ix] == 0
            d = solve!(DM, A, ix, E)
            if d < D
                D = d
            end
        end
    end
    return D
end

@test part_2(testinput) == 29
@test part_2(input) == 354
@info "Part2:" part_2(input)
