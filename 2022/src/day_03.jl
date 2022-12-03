# https://adventofcode.com/2022/day/3
using AdventOfCode
using Test

input = "2022/data/day_03.txt"
testinput = "2022/data/test_03.txt"

function priority(c::Char)
    if islowercase(c)
        return codepoint(c) - 96
    else
        return codepoint(c) - 38
    end
end

function common(s1, s2)
    for s in s1
        for ss in s2
            if s == ss
                return s
            end
        end
    end
end

function common(s1, s2, s3)
    for s in s1, ss in s2
        if s == ss
            for sss in s3
                if s == sss
                    return s
                end
            end
        end
    end
end

function part_1(input)
    s = 0
    for l in eachline(input)
        n = div(length(l), 2)
        s = s + priority(common(view(l, 1:n), view(l, n+1:n+n)))
    end
    return s
end
@test part_1(testinput) == 157
@test part_1(input) == 7908
@info part_1(input)

function part_2(input)
    s = 0
    sacks = []
    for l in eachline(input)
        push!(sacks, l)
        if length(sacks) == 3
            s = s + priority(common(sacks...))
            sacks = []
        end
    end
    return s
end
@test part_2(testinput) == 70
@test part_2(input) == 2838
@info part_2(input)
