# https://adventofcode.com/2021/day/3
using AdventOfCode
using LinearAlgebra
using Test

input = readlines("2021/data/day_3.txt")

function to_matrix(input)
    I = length(input)
    J = length(input[1])
    A = zeros(Bool,I,J)
    for (i,l) in enumerate(input)
        for (j,v) in enumerate(l)
            if v == '1'
                A[i,j] = true
            end
        end
    end
    return A
end

bin2int(v) = dot(Iterators.reverse((2^(i-1) for i in 1:length(v))), v)

function part_1(input)
    A = to_matrix(input)
    γ = sum(A, dims=1) .> size(A,1) / 2
    ϵ = .!γ
    bin2int(γ) * bin2int(ϵ)
end
@info part_1(input)

most_common(A) = view(A,view(A,:,1).>0,:)
most_common(A,pos,most=true) = most ? sum(view(A,:,pos).>0)>=size(A,1)/2 : sum(view(A,:,pos).>0)<size(A,1)/2

function magicnumber(A,most=true)
    B = view(A,:,:)
    for pos = 1:size(A,1)
        B = view(B,view(B, :,pos) .== most_common(B,pos,most),:)
        if size(B,1) == 1
            break
        end
    end
    bin2int(B)
end

function part_2(input)
    A = to_matrix(input)
    magicnumber(A) * magicnumber(A,false)
end
@info part_2(input)

@testset "December 3" begin
    @test part_1(input) == 4191876
    @test part_2(input) == 3414905
end




#=
 First quick and dirty version: 


function part_1_old(input)
    rows = length(input[1])
    columns = length(input)
    A = zeros(columns,rows)
    for (i,l) in enumerate(input)
        for (j,v) in enumerate(l)
            if v == '1'
                A[i,j] = 1
            end
        end
    end
    γ = parse(Int,join(collect(d==1 ? "1" : "0" for d in (sum(A,dims=1).>length(input)/2)));base=2)#sum(A,dims=1).>500#most_common(input)
    ϵ = parse(Int,join(collect(d==1 ? "1" : "0" for d in (sum(A,dims=1).<=length(input))));base=2)
    # @info γ ϵ

    γ * ϵ
end
# @info part_1(input)


function common(input)
    rows = length(input[1])
    columns = length(input)

    A = zeros(columns,rows)
    for (i,l) in enumerate(input)
        for (j,v) in enumerate(l)
            if v == '1'
                A[i,j] = 1
            end
        end
    end

    most_common = sum(A,dims=1).>=length(input)/2
    least_common = sum(A,dims=1).<length(input)/2
    return most_common,least_common
end

common_chars(input) = [d >0 ? '1' : '0' for d in input]

filterchar(input, char, pos) = filter!(x->x[pos]==char,input)



function part_2_old(input)
    
    most_common,least_common = common(input)


    most_common_chars = common_chars(most_common)#[d >0 ? '1' : '0' for d in most_common]
    f1 = copy(input)
    n1 = 0
    for pos = 1:length(f1)
        most_common,_ = common(f1)
        comchar = common_chars(most_common)
        filterchar(f1, comchar[pos],pos)
        # @info comchar f1 
        if length(f1)==1
            n1 = parse(Int, f1[1],base=2)
            break
        end
    end
    
    f1 = copy(input)
    n2 = 0
    for pos = 1:length(f1)
        _,most_common = common(f1)
        comchar = common_chars(most_common)
        filterchar(f1, comchar[pos],pos)
        # @info comchar f1 
        if length(f1)==1
            n2 = parse(Int, f1[1],base=2)
            break
        end
    end
    
    # @info n1 n2
    
    
    
    return n1 * n2







    for l in f1
        for (cx,c) in enumerate(most_common_chars)
            filter!(x->x[cx]==c,f1)
            @info c f1
            if length(f1) == 1
                n1 = parse(Int, f1[1],base=2)
            end
        end
    end
    
    least_common_chars = [d >0 ? '1' : '0' for d in least_common]
    f2 = copy(input)
    n2 = 0
    for l in f2
        for (cx,c) in enumerate(least_common_chars)
            filter!(x->x[cx]==c,f2)
            @info c f2
            if length(f2) == 1
                n2 = parse(Int, f2[1];base=2)
            end
        end
    end
    @info n1
    @info n2
    
    
    return n1 * n2


    # Keep only numbers selected by the bit criteria for the type of rating value for which you are searching. Discard numbers which do not match the bit criteria.
        # If you only have one number left, stop; this is the rating value for which you are searching.
        # Otherwise, repeat the process, considering the next bit to the right.



    #To find oxygen generator rating, determine the most common value (0 or 1) in the current bit position, and keep only numbers with that bit in that position. If 0 and 1 are equally common, keep values with a 1 in the position being considered.

    #To find CO2 scrubber rating, determine the least common value (0 or 1) in the current bit position, and keep only numbers with that bit in that position. If 0 and 1 are equally common, keep values with a 0 in the position being considered.


    nothing
end
# @info part_2(input)
=#

nothing