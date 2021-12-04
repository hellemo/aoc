# https://adventofcode.com/2021/day/4
using AdventOfCode
using Test

input = readlines("2021/data/day_4.txt")
testinput = readlines("2021/data/day_4_test.txt")

function parse_input(input)
    draws = parse.(Int,split(input[1],",") )
    nboards = length(input) - 1
    boards = []
    for b = 3:6:nboards
        # @info b
        # @info nboards
        board = zeros(Int,5,5)
        binput = split.(input[b:b+4])
        for (i,bl) in enumerate(binput)
            # @info bl
            board[i,:] = parse.(Int,bl)
        end
        # @info board
        push!(boards,board)
    end
    return draws,boards
end

function score_board(board,checked)
    sum(board[.!checked])
end

function part_1(input)
    draws, boards = parse_input(input)
    checked = [b .== -1 for b in boards] 

    final_draw = 0
    final_board = 0
    for d in draws[1:end]
        for (ci,c) in enumerate(checked)
            checked[ci] = c .|| d .== boards[ci]
            if sum(sum(checked[ci],dims=1).>4 )>0 || sum(sum(checked[ci],dims=2).>4)>0
                final_draw = d
                final_board = ci
                return score_board(boards[final_board],checked[final_board]) * final_draw
            end
        end
    end
end
@info part_1(input)

function part_2(input)
    draws, boards = parse_input(input)
    checked = [b .== -1 for b in boards] 
    already_won = zeros(Bool, length(checked))
    final_draw = 0
    final_board = 0
    for d in draws[1:end]
        for (ci,c) in enumerate(checked)
            if !already_won[ci]
                checked[ci] = c .|| d .== boards[ci]
                if sum(sum(checked[ci],dims=1).>4 )>0 || sum(sum(checked[ci],dims=2).>4)>0
                    final_draw = d
                    final_board = ci
                    already_won[ci] = true
                end
            end
        end
    end
    return score_board(boards[final_board],checked[final_board]) * final_draw
end
@info part_2(input)

@testset "December 4" begin
    @test part_1(input) == 11774
    @test part_2(input) == 4495
end
nothing