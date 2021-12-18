# https://adventofcode.com/2021/day/18
using AdventOfCode
using Test
import Base: +

input = readlines("2021/data/day_18.txt")
testinput = readlines("2021/data/day_18_test.txt")
testinput2 = readlines("2021/data/day_18_test2.txt")

struct SnailNumber
    level::Array{Int}
    number::Array{Int}
end
SnailNumber(s::String) = SnailNumber(parse_snail_string(s))
SnailNumber(t::Tuple) = SnailNumber(first(t), last(t))
+(x::SnailNumber, y::SnailNumber) = addr(x, y)
Base.show(io::IO, sn::SnailNumber) = print(io, "$(sn.number)")
addsn(a::SnailNumber,b::SnailNumber) = SnailNumber(vcat(a.level,b.level).+1, vcat(a.number,b.number)) # just add
addr(sn1::SnailNumber,sn2::SnailNumber) = reduce(addsn(sn1,sn2)) # Add and reduce

function parse_snail_string(l)
    level = []
    number = []
    current_level = 0
    for c in l
        if c == '['
            current_level += 1
        elseif c == ']'
            current_level -= 1
        elseif isnumeric(c)
            push!(number, parse(Int,c))
            push!(level, current_level)
        end
    end
    return level, number
end

magnitude(a,b) = 3 * a + 2 * b 
function magnitude(sn::SnailNumber)
    level = sn.level
    number = sn.number
    while length(number) > 1
        N = length(number)
	    done = false
	    for i in 1:N
	        if !done && i < N  && level[i] == level[i+1] ## pair
	       	    number[i] = magnitude(number[i], number[i+1])
	    	    level[i] -=1
		        number = vcat(number[1:i], number[i+2:end])
	    	    level = vcat(level[1:i], level[i+2:end])
                done = true
            end
        end
    end
    return only(number)
end

function reduce(sn::SnailNumber)
    r, dn = explode(sn)
    !dn && return reduce(r)
    r, dn = split(sn)
    !dn && return reduce(r)
    return r
end

explode(sn::SnailNumber) = explode(sn.level, sn.number)
explode(t::Tuple) = explode(first(t),last(t))
function explode(level, number)
    for i = 1:length(number)
        if level[i]>4            
            if i < length(number) && level[i] == level[i+1] # explode pair
	       	    if i > 1
                    number[i-1] += number[i]
                end
                if i < length(number) -1
                    number[i+2] += number[i+1]
                end
                number[i] = 0
                level[i] -=1
                return SnailNumber(vcat(level[1:i],level[i+2:end]), vcat(number[1:i],number[i+2:end])) ,false
            end
        end
    end
    return SnailNumber(level, number), true
end

split(sn::SnailNumber) = split(sn.level, sn.number)
split(t::Tuple) = split(first(t),last(t))
function split(level, number)
    for i = 1:length(number)
            if number[i] > 9 # split
                @debug i
                n = number[i]
                l, r = Int(floor(n/2)), Int(ceil(n/2))
                number[i] = l
                level[i] += 1
                return SnailNumber(vcat(level[1:i],[level[i]],level[i+1:end]),
                       vcat(number[1:i],[r],number[i+1:end])), false
            end
    end
    return SnailNumber(level, number), true
end

function part_1(input)
    magnitude(foldl(+, SnailNumber.(input)))
end
@info part_1(input)

function part_2(input)
    sns = SnailNumber.(input)
    maxmag = 0
    for i in sns, j in sns
        maxmag = maximum((maxmag, magnitude(i+j), magnitude(j+i)))
    end
    return maxmag
end
@info part_2(input)

@testset "December 18" begin
    @test part_1(testinput) == 4140
    @test part_1(input) == 3987

    @test part_2(testinput) == 3993
    @test part_2(input) == 4500
end