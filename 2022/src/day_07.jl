# https://adventofcode.com/2022/day/7
using AdventOfCode
using Test

input = "2022/data/day_07.txt"
testinput = "2022/data/test_07.txt"

struct File
    name::String
    size::Int
end

abstract type AbstractDir end
struct NoDir <: AbstractDir end
mutable struct Dir <: AbstractDir
    name::AbstractString
    dirs::Vector{Dir}
    files::Vector{File}
    parent::AbstractDir
end

root = Dir("/", Dir[], File[], NoDir())

function add_dir(pd::Dir, n)
    if n in (x -> x.name for x in pd.dirs)
        nothing
    else
        push!(pd.dirs, Dir(n, Dir[], File[], pd))
    end
end

function add_file(f::AbstractString, pd::Dir, n::Int)
    if f in (x -> x.name for x in pd.files)
        nothing
    else
        push!(pd.files, File(f, n))
    end
end

function cd(pd::Dir, s::AbstractString)
    if s == ".."
        if pd.parent == NoDir()
            return pd
        else
            return pd.parent
        end
    elseif s == "/"
        getroot(pd)
    else
        for d in pd.dirs
            if d.name == s
                return d
            end
        end
    end
end
getroot(d::NoDir) = NoDir()
function getroot(d::Dir)
    if typeof(d) == NoDir
        return d
    else
        return getroot(d.parent)
    end
end

function parse_data(input)
    root = Dir("/", Dir[], File[], NoDir())
    pwd = root
    cmd = ""
    for l in eachline(input)
        if startswith(l, '$')
            cmd = ""
            s = split(l)
            if length(s) == 3
                _, c, p = s
                cmd = c
            elseif length(s) == 2
                _, c = s
                cmd = c
            end
        end
        if cmd == "ls"
            s = split(l)
            if first(s) == "dir"
                add_dir(pwd, last(s))
            elseif isdigit(first(first(s)))
                add_file(last(s), pwd, parse(Int, first(s)))
            end
        elseif cmd == "cd"
            s = split(l)
            pwd = cd(pwd, last(s))
            if pwd == NoDir()
                # @warn "pwd == NoDir"
                pwd = root
            end
        end
    end
    return root
end

function calsize(d::Dir)
    fs = 0
    for f in d.files
        fs = fs + f.size
    end
    for sd in d.dirs
        fs = fs + calsize(sd)
    end
    return fs
end

function solve(root, maxdepth=10)
    dirs = []
    push!(dirs, calsize(root))
    d_p = root.dirs
    for depth = 1:maxdepth
        d_n = []
        for d in d_p
            push!(dirs, calsize(d))
            push!(d_n, d.dirs...)
        end
        d_p = d_n
        if length(d_p) == 0
            break
        end
    end
    return dirs
end

function part_1(input)
    v = solve(parse_data(input))
    return sum(v[v.<=100_000])
end

@test part_1(testinput) == 95437
@test part_1(input) == 1182909
@info "Part1:" part_1(input)

function part_2(input)
    v = solve(parse_data(input))
    sort!(v)
    total = 70000000
    need = 30000000
    used = last(v)
    unused = total - used
    required = need - unused
    i = findfirst(x -> x >= required, v)
    return v[i]
end

@test part_2(testinput) == 24933642
@test part_2(input) == 2832508
@info "Part2:" part_2(input)
