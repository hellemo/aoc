# https://adventofcode.com/2022/day/8
using AdventOfCode
using Test

input = "2022/data/day_08.txt"
testinput = "2022/data/test_08.txt"

function parse_data(input)
    D = split(chomp(read(input, String)), "\n")
    M = length(D)
    N = length(first(D))
    A = Array{Int}(undef, M, N)
    for i = 1:M, j = 1:N
        A[i, j] = parse(Int, D[i][j])
    end
    return A
end

function from_left(A)
    M = copy(A)
    V = zeros(Bool, size(A))
    for i = 1:size(A, 1)
        for j = 2:size(A, 2)
            M[i, j] = max(M[i, j-1], A[i, j])
            if A[i, j] > M[i, j-1]
                V[i, j] = 1
            end
        end
    end
    V[end, :] .= true
    V[begin, :] .= true
    V[:, begin] .= true
    V[:, end] .= true
    return V
end

function solve(A)
    V = from_left(A)
    V = V .|| rotl90(from_left(rotr90(A)))
    V = V .|| rot180(from_left(rot180(A)))
    V = V .|| rotr90(from_left(rotl90(A)))
    return sum(V)
end

function scenic_scores(A)
    M, N = size(A)
    left = [CartesianIndex(0, -i) for i = 1:N]
    right = [CartesianIndex(0, i) for i = 1:N]
    up = [CartesianIndex(-i, 0) for i = 1:M]
    down = [CartesianIndex(i, 0) for i = 1:M]
    scores = zeros(Int, size(A))
    for i in CartesianIndices(A)
        scores[i] = prod(score_direction(A, i, d) for d in [left, right, up, down])
    end
    return scores
end

function score_direction(A, point, dir)
    score = 0
    for d in dir
        if checkbounds(Bool, A, point + d)
            if A[point+d] < A[point]
                score = score + 1
            else
                return score + 1
            end
        end
    end
    return score
end

function part_1(input)
    solve(parse_data(input))
end

@test part_1(testinput) == 21
@test part_1(input) == 1538
@info "Part1:" part_1(input)

function part_2(input)
    maximum(scenic_scores(parse_data(input)))
end

@test part_2(testinput) == 8
@test part_2(input) == 496125
@info "Part2:" part_2(input)
