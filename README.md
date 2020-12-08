# StarBattle

[![Stable](https://img.shields.io/badge/docs-stable-blue.svg)](https://ngngardner.github.io/StarBattle.jl/stable)
[![Dev](https://img.shields.io/badge/docs-dev-blue.svg)](https://ngngardner.github.io/StarBattle.jl/dev)
[![Build Status](https://travis-ci.com/ngngardner/StarBattle.jl.svg?branch=master)](https://travis-ci.com/ngngardner/StarBattle.jl)
[![Coverage](https://codecov.io/gh/ngngardner/StarBattle.jl/branch/master/graph/badge.svg)](https://codecov.io/gh/ngngardner/StarBattle.jl)

The purpose of this repository is to house a Star Battle Puzzle solver written
in Julia.

## Install

Dependencies required to run both notebooks:
- BenchmarkTools
- CSV
- DataFrames
- Parameters
- Revise
- SimpleGraphs
- SimpleGraphAlgorithms
- Tables

```
# Install dependencies...
# press ']' in the julia REPL to enter the package interface
# then run the following:

add BenchmarkTools
add CSV
add DataFrames
add Parameters
add Revise
add SimpleGraphs
add SimpleGraphAlgorithms
add Tables
```

## Usage

Notebooks can be run using Pluto.

```
# exit the package interface with 'backspace'
using Pluto
Pluto.run()

# then, select Graphs.notebook.jl to investigate the graph-based solver,
# or notebook.jl to investigate the backtracking algorithms
```
