### A Pluto.jl notebook ###
# v0.12.15

using Markdown
using InteractiveUtils

# ╔═╡ 00cf0252-29f7-11eb-385c-97cb93db5e2f
begin
	import Revise
	import CSV
	
	using BenchmarkTools
	using DataFrames
	using StarBattle
end

# ╔═╡ e9ba30ee-3418-11eb-154d-07fa951d9808
function output_cells(cells)
	d, n = size(cells)
	res = Array{String}(undef, d, d)

	for i in 1:d
		for j in 1:n
			if cells[i, j].is_star
				res[i, j] = "☆"
			else
				res[i, j] = "_"
			end
		end
	end
	return res
end

# ╔═╡ 4f983fc2-3418-11eb-16cc-fb68b374adcb
begin	
	input_file = "data/8puzzle2.data"
	k = 1
	
	df = CSV.read(input_file, DataFrame, header=false)
	puzzle = convert(Matrix, df)
end

# ╔═╡ 1f59446a-3405-11eb-266d-a5abba161174
begin
	res = graph_solve(puzzle)
	output_cells(res.cells)
end

# ╔═╡ Cell order:
# ╠═00cf0252-29f7-11eb-385c-97cb93db5e2f
# ╠═e9ba30ee-3418-11eb-154d-07fa951d9808
# ╠═4f983fc2-3418-11eb-16cc-fb68b374adcb
# ╠═1f59446a-3405-11eb-266d-a5abba161174
