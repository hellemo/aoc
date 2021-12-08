# https://adventofcode.com/2021/day/8
using AdventOfCode
using Test

input = readlines("2021/data/day_8.txt")
testinput = readlines("2021/data/day_8_test.txt")

function parse_input2(input)
    is = []
    os = []
    for l in input
        ls = split(l, "|")
        if length(ls)>1
            push!(is, split(chomp(ls[1])))
            push!(os, split(chomp(ls[2])))
        end
    end
    return is, os
end

function unique_digits(counts)
    retc = 0
    for c in counts
        if c ∈ [2,3,4,7]
            retc += 1
        end
    end
    retc
end

function part_1(input)
    is,os = parse_input2(input)
    icounts = [] 
    ocounts = []
    for i = 1:length(is)
        if length(is[1])>1
            iis = length.(is[i])
            oos = length.(os[i])
            push!(icounts, iis)
            push!(ocounts ,oos)
        end
    end
    return sum(unique_digits.(ocounts))
end
@info part_1(input)


function decode2(codes)
    secret = Dict()
    # Unique first
    for code in codes
        if length(code) == 2 
            secret[1] = [c for c in code]
        elseif length(code) == 3
            secret[7] = [c for c in code]
        elseif length(code) == 4
            secret[4] = [c for c in code]
        elseif length(code) == 7
            secret[8] = [c for c in code]
        end
    end    
    # Rest of values

    function check_n(code, n)
        d = symdiff(code, secret[n])
        n = length(d)
        return d,n
    end
    for code in sort(codes, by=length)
        if length(code) == 5 # 2, 3, 5
            d, n = check_n(code, 4)     
            if n == 5
                secret[5] = [c for c in code]
            end
            d, n = check_n(code, 1)
            if n == 3
                secret[3] = [c for c in code]
            end 
        elseif length(code) == 6 # 0, 6, 9
            d, n = check_n(code, 1)
            if n == 6
                secret[6] = [c for c in code]
            end
            d, n = check_n(code, 4)
            if n == 2
                secret[9] = [c for c in code]
            end
        end
    end
    # Using previously computed values
    secret[2] = setdiff(secret[8], union(
                                        setdiff(secret[1],secret[5]),
                                        setdiff(secret[4],secret[3])))
    secret[0] = setdiff(secret[8], 
                                setdiff(setdiff(secret[3],secret[7]),
                                setdiff(secret[3],secret[4])))
    # Return dictionary to decode codes:
    dec = Dict()
    for k in keys(secret)
        dec[join(sort(secret[k],by=codepoint))] = k
    end
    return secret, dec
end

function part_2(input)
    is,os = parse_input2(input)
    retval = 0
    for i = 1:length(is)
        allvals = vcat(is[i],os[i])
        _,dec =  decode2(allvals)
        thisnum = 0
        for (p,d) in enumerate(os[i])
            lookupkey = join(sort([c for c in d],by=codepoint))
            if haskey(dec,lookupkey)
                lookupval = dec[lookupkey]
                thisnum += 10^(4-p) * lookupval
            else # Allow one single missing value (bug?)
                thisnum += 10^(4-p) * only(setdiff(0:9,values(dec)))
            end
        end
        retval += thisnum
    end
    return retval
end
@info part_2(input)

@testset "December 8" begin
    @test part_1(testinput) == 26
    @test part_1(input) == 397

    @test part_2(testinput) == 61229
    @test part_2(input) == 1027422
end
nothing