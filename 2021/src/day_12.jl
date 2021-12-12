# https://adventofcode.com/2021/day/12
using AdventOfCode
using Test

input = readlines("2021/data/day_12.txt")
testinput = readlines("2021/data/day_12_test1.txt")
testinput2 = readlines("2021/data/day_12_test2.txt")
testinput3 = readlines("2021/data/day_12_test3.txt")

# Faster lookups with Symbols, but needs islowercase method for Symbols
import Base.islowercase
const IS_LOWER = Dict{Symbol,Bool}()
function islowercase(a::Symbol)
    if haskey(IS_LOWER, a)
        return IS_LOWER[a]
    else
        s = String(a)
        IS_LOWER[a] = islowercase(first(s))
        return IS_LOWER[a]
    end
end

function parse_input(input)
    connections = []
    for l in input
        from, to = split(l, "-")
        push!(connections, Symbol(from)=>Symbol(to))
    end
    return connections
end

function unique_nodes(connections)
    unique(vcat(unique(c.first for c in connections),
                unique(c.second for c in connections)))
end

function traverse(checkrules::Function, node, outnodes, visited::Dict{Symbol,UInt8})
    node == :end && return 1
    visited[node] = visited[node] + 1
    sumout = 0
    for n in outnodes[node]
        if checkrules(n, visited)
            sumout += traverse(checkrules, n, outnodes, copy(visited))
        end
    end
    return sumout
end

function make_outs(connections)
    outpaths = Dict{Symbol,Vector{Symbol}}()
    for c in connections
        if haskey(outpaths,c.first)
            push!(outpaths[c.first],c.second)
        else
            outpaths[c.first] = [c.second]
        end
        if haskey(outpaths,c.second)
            push!(outpaths[c.second],c.first)
        else
            outpaths[c.second] = [c.first]
        end
    end
    return outpaths
end

rule_1(n, visited) = !haskey(visited,n) || visited[n]<1 || !islowercase(n)

function solve(input, rule=rule_1)
    connections = parse_input(input)
    nodes = unique_nodes(connections)
    visited = Dict(zip(nodes, zeros(UInt8, length(nodes))))
    outpaths = make_outs(connections)
    traverse(rule, :start, outpaths, visited)
end

function part_1(input)
    return solve(input, rule_1)
end
@info part_1(input)

# Shorter, but slower
# doublenotused(visited) = !(2 in values(filter(x->islowercase(x), visited)))
function doublenotused(visited)
    for k in keys(visited)
        if (islowercase(k)) && (visited[k] > 1) 
            return false
        end
    end
    return true
end

function rule_2(node, visited)
    if node in (:start, :end)
        return visited[node] < 1
    elseif islowercase(node)
        if visited[node] < 1
            return true
        elseif (visited[node] < 2) && (doublenotused(visited))
            return true
        end
    else
        return true
    end
    return false
end

function part_2(input)
    solve(input, rule_2)
end
@info part_2(input)

@testset "December 12" begin
    inputs = (testinput, testinput2, testinput3, input)
    p1 = [10, 19, 226, 4792]
    p2 = [36, 103, 3509, 133360]
    for (i, f) in enumerate(inputs)
        @test part_1(f) == p1[i]
        @test part_2(f) == p2[i]
    end
end
nothing
