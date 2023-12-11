# https://adventofcode.com/2023/day/11
using AdventOfCode
using SparseArrays
using Test

input = "2023/data/day_11.txt"
testinput = "2023/data/test_11.txt"

function parse_data(input)
    sparse(stack(eachline(input)) .== '#')
end

function solve(A, N = 1)
    galaxies = findall(A)
    expandrows = Int[]
    for (i, r) in enumerate(eachrow(A))
        if sum(r) == 0
            push!(expandrows, i)
        end
    end
    expandcols = Int[]
    for (i, c) in enumerate(eachcol(A))
        if sum(c) == 0
            push!(expandcols, i)
        end
    end
    alldist = 0
    for (i, g1) in enumerate(galaxies)
        for (j, g2) in enumerate(galaxies[i+1:end])
            alldist = alldist + distance(g1, g2, expandrows, expandcols, N)
        end
    end
    return alldist
end


function distance(a, b, xr, xc, N)
    b < a && return distance(b, a, xr, xc, N)
    s = a - b
    direct = sum(abs.(s.I))

    minr, maxr = extrema((first(a.I), first(b.I)))
    minc, maxc = extrema((last(a.I), last(b.I)))

    extrarows = length(xr[xr.>minr.&&xr.<maxr]) * (N - 1)
    extracols = length(xc[xc.>minc.&&xc.<maxc]) * (N - 1)

    return direct + extracols + extrarows
end



function part_1(input, N = 2)
    A = parse_data(input)
    solve(A, N)
end

@test part_1(testinput) == 374
@test part_1(input) == 9681886
@info "Part1:" part_1(input)

function part_2(input)
    part_1(input, 1_000_000)
end

@test part_2(testinput) == 82000210
@test part_2(input) == 791134099634
@info "Part2:" part_2(input)
