
using SimpleGraphs
using SimpleGraphAlgorithms

include("solver.jl")

function cell_dist(a::Cell, b::Cell)
    return sqrt((a.row - b.row)^2 + (a.col - b.col)^2)
end

function adj_matrix(puzzle)
    d, n = size(puzzle)

    # fill cells array
    cells = Array{Cell}(undef, d, d)
    fill_cells!(cells, puzzle)
    adj = zeros(Int, n * n, n * n)

    for i = 1:n*n
        for j = 1:n*n
            if (
                (cells[i].row == cells[j].row) ||
                (cells[i].col == cells[j].col) ||
                (cells[i].group == cells[j].group) ||
                cell_dist(cells[i], cells[j]) < 2
            )
                adj[i, j] = 1
            end
        end
    end

    return adj, cells
end

function graph_solve(puzzle)
    adj, cells = adj_matrix(puzzle)
    g = SimpleGraph(adj)
    m = max_indep_set(g)

    for i in m
        cells[i].is_star = true
    end

    return StarBattleResult(cells, 0)
end
