# https://adventofcode.com/2022/day/11
using AdventOfCode
using Test

input = "2022/data/day_11.txt"
testinput = "2022/data/test_11.txt"

struct Monkey
    num::Int
    items::Vector{Int}
    operation::String
    test::Int
    truemonkey::Int
    falsemonkey::Int
end

function parse_data(input)
    monkey = 0
    monkeys = Monkey[]
    vals = Int[]
    operation = ""
    test = 0
    totrue = 0
    tofalse = 0
    for l in eachline(input)
        m = match(r"Monkey (\d+):", l)
        if !isnothing(m) # New Monkey
            monkey = parse(Int, m[1])
        else
            if contains(l, "Starting items:")
                s = split(l, ":")
                vals = parse.(Int, split(last(s), ","))
            elseif contains(l, "Operation:")
                s = split(l, "new = ")
                operation = last(s)
            elseif contains(l, "Test:")
                s = split(l, "divisible by")
                test = parse(Int, last(s))
            elseif contains(l, "If true:")
                s = split(l, "to monkey")
                totrue = parse(Int, last(s))
            elseif contains(l, "If false:")
                s = split(l, "to monkey")
                tofalse = parse(Int, last(s))
            else
                push!(monkeys, Monkey(monkey, vals, operation, test, totrue, tofalse))
            end
        end
    end
    return monkeys
end

const M = 19 * 11 * 7 * 13 * 2 * 5 * 3 * 23 * 17
struct Part1 end
struct Part2 end

m(n, part::Part1) = n
m(n, part::Part2) = mod(n, M)
r(n, part::Part1) = div(n, 3)
r(n, part) = n

function turn(monkey, monkeys, inspections, part = Part1())
    inspections[monkey.num+1] += length(monkey.items)
    s = split(monkey.operation)
    for old in copy(monkey.items)
        n = old
        if isdigit(last(last(s)))
            n = parse(Int, last(s))
        end
        if s[end-1] == "*"
            wl = m(old, part) * m(n, part)
        else
            wl = m(old, part) + m(n, part)
        end
        wl = r(wl, part)
        if wl % monkey.test == 0
            passtomonkey = monkeys[monkey.truemonkey+1]
        else
            passtomonkey = monkeys[monkey.falsemonkey+1]
        end
        push!(passtomonkey.items, wl)
        popfirst!(monkey.items)
    end
end

function round(monkeys, inspections, part = Part1())
    for m in monkeys
        turn(m, monkeys, inspections, part)
    end
end

function solve(input, rounds = 20, part = Part1())
    monkeys = parse_data(input)
    inspections = zeros(Int, length(monkeys))
    for _ = 1:rounds
        round(monkeys, inspections, part)
    end
    monkey_business = prod(first(sort(inspections; rev = true), 2))
end

function part_1(input)
    solve(input)
end

@test part_1(testinput) == 10605
@test part_1(input) == 90882
@info "Part1:" part_1(input)

function part_2(input, rounds = 10_000)
    return solve(input, rounds, Part2())
end

@test part_2(testinput) == 2713310158
@test part_2(input) == 30893109657
@info "Part2:" part_2(input)
