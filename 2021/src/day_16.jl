# https://adventofcode.com/2021/day/16
using AdventOfCode
using Test

input = readlines("2021/data/day_16.txt")[1]
testinput = "D2FE28"

const D = Dict(
        '0' => "0000",
        '1' => "0001",
        '2' => "0010",
        '3' => "0011",
        '4' => "0100",
        '5' => "0101",
        '6' => "0110",
        '7' => "0111",
        '8' => "1000",
        '9' => "1001",
        'A' => "1010",
        'B' => "1011",
        'C' => "1100",
        'D' => "1101",
        'E' => "1110",
        'F' => "1111",
    )

hex2bin(input) = join(D[c] for c in chomp(input))

function parse_packets(bits, N)
    toparse = bits
    res = []
    rest = nothing
    for _ in 1:N
        r = parse_packets(toparse)
        push!(res, r[1:end-1])
        toparse = r[end]
        rest = r[end]
    end
    return res, rest
end

function parse_packets(bits)
    V = parse(Int, bits[1:3], base=2) # VERSION
    T = parse(Int, bits[4:6], base=2) # TYPE
    counter = 7
    literal = []
    L = 0
    LEN = 0
    SUBPACKETS = []
    if T == 4 # Literal
        @debug "Literal"
        while true
            push!(literal, bits[counter+1:counter+4])
            counter += 5
            bits[counter-5] == '0' && break
        end
        L = parse(Int, join(literal),base=2)
        rest = bits[counter:end]
    else # Operator
        @debug "Operator: $(bits[7])"
        if bits[7] == '0' # Number of bits of sub-packets
            LEN = parse(Int, bits[8:8+14], base=2)
            to_parse = bits[23:23+LEN-1]
            while length(to_parse)>0
                r = parse_packets(to_parse)
                push!(SUBPACKETS, r[1:end-1])
                to_parse = r[end]
            end
            rest = bits[23+LEN:end]
        else # Number of sub-packets
            LEN = parse(Int, bits[8:8+10], base=2)
            ps, rest = parse_packets(bits[19:end], LEN)
            push!(SUBPACKETS, ps)
        end
    end
    return V,T,L,LEN,SUBPACKETS, rest
end

function sumversions(ps::Tuple)
    return ps[1] + sumversions(ps[5])
end
function sumversions(ps::Vector)
    isempty(ps) && return 0
    s = [sumversions(i) for i in ps]
    return sum(s)
end

function part_1(input)
    BITS = hex2bin(input)
    t = parse_packets(BITS)
    sumversions(t)
end
@info part_1(input)

decode(x::Number) = x
function decode(ps::Tuple)
    ps[2] == 4 && return ps[3]
    ptype = ps[2] + 1
    fs = [sum, prod, minimum, maximum, identity,
          x->Int(x[1]>x[2]),
          x->Int(x[1]<x[2]),
          x->Int(x[1]==x[2]),
    ]
    f = fs[ptype]
    return f(decode(ps[5]))
end
function decode(ps::Vector)
    length(ps) == 1 && return decode(ps[1])
    [decode(i) for i in ps]
end

function part_2(input)
    BITS = hex2bin(input)
    t = parse_packets(BITS)
    decode(t)
end
@info part_2(input)

@testset begin
    @test part_1("8A004A801A8002F478") == 16
    @test part_1("620080001611562C8802118E34") == 12
    @test part_1("C0015000016115A2E0802F182340") == 23
    @test part_1("A0016C880162017C3686B18A3D4780") == 31
    @test part_1(input) == 913
    
    @test part_2("D2FE28") == 2021
    @test part_2("C200B40A82") == 3
    @test part_2("04005AC33890") == 54
    @test part_2("880086C3E88112") == 7
    @test part_2("CE00C43D881120") == 9
    @test part_2("D8005AC2A8F0") == 1
    @test part_2("F600BC2D8F") == 0
    @test part_2("9C005AC2F8F0") == 0
    @test part_2("9C0141080250320F1802104A08") == 1
    @test part_2(input) == 1510977819698
end