# StarBattle

[![Stable](https://img.shields.io/badge/docs-stable-blue.svg)](https://ngngardner.github.io/StarBattle.jl/stable)
[![Dev](https://img.shields.io/badge/docs-dev-blue.svg)](https://ngngardner.github.io/StarBattle.jl/dev)
[![Build Status](https://travis-ci.com/ngngardner/StarBattle.jl.svg?branch=master)](https://travis-ci.com/ngngardner/StarBattle.jl)
[![Coverage](https://codecov.io/gh/ngngardner/StarBattle.jl/branch/master/graph/badge.svg)](https://codecov.io/gh/ngngardner/StarBattle.jl)

The purpose of this repository is to house a Star Battle Puzzle solver written
in Julia.

## Install

`using Pkg; Pkg.add(url="https://github.com/ngngardner/StarBattle.jl")`

## Usage

```
import CSV
using DataFrames
using StarBattle

df = CSV.read("data/10puzzle1.data")
puzzle = convert(Matrix, df)
k = 2

result = solve(puzzle, k)
```

Other examples can be seen in the notebook branch.
