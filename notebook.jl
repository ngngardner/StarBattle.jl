### A Pluto.jl notebook ###
# v0.12.4

using Markdown
using InteractiveUtils

# ╔═╡ d982dbe0-159e-11eb-0465-914f9fed106d
begin
	import Revise
	import CSV
	
	using BenchmarkTools
	using StarBattle
end

# ╔═╡ 5e5e1790-1968-11eb-3146-fd204364a0fc
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
	res
end

# ╔═╡ ef3dc170-159e-11eb-0a02-353f233d8b90
begin
	input_file = "data/5puzzle1.data"
	k = 1
	
	df = CSV.read(input_file, header=false)
	puzzle = convert(Matrix, df)
	
end

# ╔═╡ 24d59650-1969-11eb-1dbb-d36c0bcbf983
begin	
	res_old = solve(puzzle, k; normal_select=true)
	output_cells(res_old.cells)
end

# ╔═╡ ac2bd8e0-1968-11eb-2c86-91f8d91a7fb7
begin	
	res_new = solve(puzzle, k; normal_select=false)
	output_cells(res_new.cells)
end

# ╔═╡ 3ab67a70-1969-11eb-1d07-6d9768ec687a
@benchmark solve(puzzle, k; normal_select=true)

# ╔═╡ db296b30-1968-11eb-085c-6f2b8ac65e70
@benchmark solve(puzzle, k; normal_select=false)

# ╔═╡ Cell order:
# ╠═d982dbe0-159e-11eb-0465-914f9fed106d
# ╠═5e5e1790-1968-11eb-3146-fd204364a0fc
# ╠═ef3dc170-159e-11eb-0a02-353f233d8b90
# ╠═24d59650-1969-11eb-1dbb-d36c0bcbf983
# ╠═ac2bd8e0-1968-11eb-2c86-91f8d91a7fb7
# ╠═3ab67a70-1969-11eb-1d07-6d9768ec687a
# ╠═db296b30-1968-11eb-085c-6f2b8ac65e70
