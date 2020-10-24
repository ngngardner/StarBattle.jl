
include("solver.jl")

"""
	Test if a solution is unique

	Prove existence of a unique solution by proving a solution is unique.

	Prove a solution is unique by showing that, for all combinations of 
	all stars in a solution, if the star is blocked (set as not a possible 
	part of the solution), and no solution can be found, the solution is unique.
"""
function unique_solution(puzzle, cells, k)
	d, n = size(puzzle)

	for i in 1:k
		stars = get_stars(cells)
		blocked = collect(combinations(1:k*n, i))
		for block in blocked
			# regions for testing solution
			regions = Dict{String,Array}(
				"rows" => Vector{Region}(undef, d),
				"cols" => Vector{Region}(undef, d),
				"groups" => Vector{Region}(undef, d),
			)

			# copy cells and fill regions based on cells
			c = deepcopy(cells)
			fill_regions!(regions, c)
			
			# unblock each cell
			for n in 1:d
				for m in 1:d
					c[m, n].is_blocked = false
				end
			end

			# get the idx of each star based on indexes from `block`
			star_idx = view(stars, block)

			# get all the stars based on `block` and remove from solution
			v = view(c, star_idx)
			for j in 1:size(v, 1)
				v[j].is_star = false
			end

			block!(c, regions, k)
			for j in 1:size(v, 1)
				v[j].is_blocked = true
			end
			update_regions!(regions, c)
			
			# try to solve with input cells and regions
			res = solve(puzzle, k)
			if !isnothing(res.cells)
				# another solution was found, the solution is not unique
				return res.cells
			end
		end
	end

	# no other solution found, the solution is unique
	return true
end
