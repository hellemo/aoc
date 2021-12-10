# https://adventofcode.com/2021/day/10
using AdventOfCode
using Test

input = readlines("2021/data/day_10.txt")
testinput = readlines("2021/data/day_10_test.txt")

struct Open end
struct Match end
struct Score1 end
struct Score2 end
struct MatchScore{N} end
# Precompute lookup-tables during compilation
@generated function fast_matching(c, ::MatchScore{M}) where M
    opens =  ('(','[','{','<')
    closes = (')',']','}','>')
    N = maximum(codepoint(i) for i in union(opens, closes))
    mat = Array{Char,1}(undef,N)
    score1 = Array{Int,1}(undef,N)
    scores1 = [3,57,1197,25137]
    score2 = Array{Int,1}(undef,N)
    scores2 = [1,2,3,4]
    op = Array{Bool,1}(undef,N)
    for i in 1:4
        mat[codepoint(opens[i])] = codepoint(closes[i])
        mat[codepoint(closes[i])] = codepoint(opens[i])
        score1[codepoint(closes[i])] = scores1[i]
        score2[codepoint(opens[i])] = scores2[i]
        op[codepoint(opens[i])] = true
        op[codepoint(closes[i])] = false
    end
    if M == Open
        return :($op[codepoint(c)])
    elseif M == Score1
        return :($score1[codepoint(c)])
    elseif M == Score2
        return :($score2[codepoint(c)])
    else
        return :($mat[codepoint(c)])
    end
end

# Convenience functions to hide types
is_open(c) = fast_matching(c, MatchScore{Open}())
find_match(c) = fast_matching(c, MatchScore{Match}())
score_1(c) = fast_matching(c, MatchScore{Score1}())
score_2(c) = fast_matching(c, MatchScore{Score2}())

function fast_1(input)
    sumscores = 0
    parens = Char[]
    for l in input
        deleteat!(parens, 1:length(parens))
        for c in l
            if is_open(c)
                push!(parens, c)
            elseif !is_open(c)
                co = pop!(parens)
                if !(co == find_match(c))
                    sumscores += score_1(c)
                    break
                end
            end
        end
    end
    return sumscores
end
@info fast_1(input)

function fast_score_parens(parens)
    sumscore = 0
    for p in reverse(parens)
        sumscore = sumscore * 5 + score_2(p)
    end
    return sumscore
end

function fast_2(input)
    finalscores = Int[]
    parens = Char[]
    for l in input
        deleteat!(parens, 1:length(parens))
        for c in l
            if is_open(c)
                push!(parens,c)
            elseif !is_open(c)
                co = pop!(parens)
                if !(co == find_match(c))
                    deleteat!(parens, 1:length(parens))
                    break
                end
            end
        end
        if length(parens) > 0
            push!(finalscores, fast_score_parens(parens))
        end
    end
    N = div(length(finalscores),2) + 1
    partialsort!(finalscores, N)
    return finalscores[N]
end
@info fast_2(input)

#=
    Original solution
=#

const scores=Dict(
    ')' => 3,
    ']' => 57,
    '}' => 1197,
    '>' => 25137,
)

function closing(c)
    c == ')' && return '('
    c == ']' && return '['
    c == '}' && return '{'
    c == '>' && return '<'
end

function part_1(input)
    opens =  ['(','[','{','<']
    closes = [')',']','}','>']
    sumscores = 0
    for l in input
        parens = Char[]
        for c in l
            if c in opens
                push!(parens,c)
            elseif c in closes
                co = pop!(parens)
                if !(co == closing(c))
                    sumscores += scores[c]
                end
            end
        end
    end
    return sumscores
end

function is_valid(l)
    opens =  ['(','[','{','<']
    closes = [')',']','}','>']
        parens = []
        for c in l
            if c in opens
                push!(parens,c)
            elseif c in closes
                co = pop!(parens)
                if !(co == closing(c))
                    return false
                end
            end
        end
    return true
end


const scores2 = Dict(
    ')'=> 1,
    ']' => 2,
    '}' => 3,
    '>' => 4,
    )

function score_parens(parens)
    matching = Dict(
        '{' => '}',
        '(' => ')',
        '<' => '>',
        '[' => ']',
    )
    sumscore = 0
    for p in reverse(parens)
        thisscore = scores2[matching[p]]
        sumscore = sumscore * 5 + thisscore
    end
    return sumscore
end


function part_2(input)
    opens =  ['(','[','{','<']
    closes = [')',']','}','>']
    finalscores = Int[]
    for l in filter(is_valid, input)
        parens = Char[]
        for c in l
            if c in opens
                push!(parens,c)
            elseif c in closes
                co = pop!(parens)
                if co == closing(c)
                    # ok
                end
            end
        end
        push!(finalscores, score_parens(parens))
    end
    N = length(finalscores)
    sort!(finalscores)
    return finalscores[div(N,2)+1]
end






@testset "December 10" begin
    @test fast_1(testinput) == part_1(testinput) == 26397
    @test fast_1(input) == part_1(input) == 294195

    @test fast_2(testinput) == part_2(testinput) == 288957
    @test fast_2(input) == part_2(input) == 3490802734
end
nothing