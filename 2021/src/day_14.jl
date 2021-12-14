# https://adventofcode.com/2021/day/14
using AdventOfCode
using Test

input = readlines("2021/data/day_14.txt")
testinput = readlines("2021/data/day_14_test.txt")

function parse_input(input)
    template = input[1]
    rules = []
    for l in 3:length(input)
        s = split(input[l], " -> ")
        push!(rules, s[1]=>s[2][1])
    end
    return template, Dict(rules)
end

function applyrule(str, rules)
    prev = ' '
    res = Char[]
    for c in str
        trykey = join((prev,c))
        if haskey(rules, trykey)
            push!(res, rules[trykey])
        end
        prev = c
        push!(res, c)
    end
    return join(res)
end

function countpairs(str, rules)
    freq = Dict{String,Int}()
    prev = ' '
    for c in str
        trykey = join((prev,c))
        if haskey(rules, trykey) && haskey(freq, trykey)
            freq[trykey] +=1
        elseif haskey(rules, trykey)
            freq[trykey] = 1
        end
        prev = c
    end
    return freq
end

function countchars(s)
    freq = Dict{Char,Int}()
    for c in s
        if haskey(freq, c)
            freq[c] += 1
        else
            freq[c] = 1
        end
    end
    return freq
end

function part_1(input, N=10)
    template, rules = parse_input(input)
    polymer = template
    for _ in 1:N
        polymer = applyrule(polymer, rules)
    end
    frequencies = values(countchars(polymer))
    maximum(frequencies) - minimum(frequencies)
end
@info part_1(input)

function step!(paircounts, lettercounts, rules)
    retpairs = Dict{String,Int}()   
    for pair in keys(paircounts)
        thischar = rules[pair]
        thiscount = paircounts[pair]
        # Insert character by rule
        if haskey(lettercounts, thischar)
            lettercounts[thischar] += thiscount
        else
            lettercounts[thischar] = thiscount
        end
        # Update pairs:
        firstpair = join((first(pair), thischar))
        lastpair =  join((thischar, last(pair)))
        for p in (firstpair, lastpair)
            if haskey(retpairs, p)
                retpairs[p] += thiscount
            else
                retpairs[p] = thiscount
            end
        end    
    end
    return retpairs
end

function part_2(input, N=40)
    template, rules = parse_input(input)
    lettercounts = countchars(template)
    paircounts = countpairs(template, rules)
    for _ in 1:N
        paircounts = step!(paircounts, lettercounts, rules)
    end
    counts = values(lettercounts)
    maximum(counts) - minimum(counts)
end
@info part_2(input)

@testset "December 14" begin
    @test part_1(testinput) == 1588
    @test part_1(input) == 2621

    @test part_2(testinput, 10) == 1588
    @test part_2(input, 10) == 2621
    @test part_2(testinput) == 2188189693529
    @test part_2(input) == 2843834241366
end


