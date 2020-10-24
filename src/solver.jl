
include("struct.jl")

_NORMAL_SELECT = true

"""
Return the number of cells in a group.
"""
function n_group_cells(cells::Array{Cell}, g::Int)
    return size(findall(x -> x.group == g, cells), 1)
end

"""
Return all coordinates that are stars
"""
function get_stars(cells)
    return findall(x -> x.is_star, cells)
end

function fill_cells!(cells, puzzle)
	d, n = size(puzzle)
	for i in 1:d
		for j in 1:n
			cell = Cell(i, j, puzzle[i, j]+1, false, false)
			cells[i, j] = cell
		end
	end
end

function fill_regions!(regions::Dict, cells::Array{Cell})
	d, n = size(cells)

	for i in 1:d
		regions["groups"][i] = Region(n_group_cells(cells, i), 0)
		regions["rows"][i] = Region(n, 0)
		regions["cols"][i] = Region(d, 0)
	end
end


function update_regions!(regions::Dict, cells::Array{Cell, 2})
	fill_regions!(regions, cells)
	d, n = size(cells)

	for cell in cells
		if cell.is_blocked || cell.is_star
			regions["rows"][cell.row].candidates -= 1
			regions["cols"][cell.col].candidates -= 1
			regions["groups"][cell.group].candidates -= 1
			if cell.is_star
				regions["rows"][cell.row].stars += 1
				regions["cols"][cell.col].stars += 1
				regions["groups"][cell.group].stars += 1
			end
		end
	end
end

function illegal(regions, k)
	to_check = [regions["rows"] regions["cols"] regions["groups"]]
	for region in to_check
		if (region.candidates < (k - region.stars))
			return true
		end	
	end
	return false
end

function block!(cells, regions, k::Int)
	d, n = size(cells)
	stars = get_stars(cells)
	blocked = []
	
	for star in stars
		b = cells[star]

		check_row = regions["rows"][b.row].stars ≥ k
		check_col = regions["cols"][b.col].stars ≥ k
		check_groups = regions["groups"][b.group].stars ≥ k
		
		# adjacent
		check_points = findall(
			a -> !a.is_star 
				&& ((check_row && a.row == b.row)			  	     # row
					|| (check_col && a.col == b.col)     		 	 # col
					|| (check_groups && a.group == b.group) 	 	 # group
					|| sqrt((a.row - b.row)^2+(a.col - b.col)^2) < 2 # adjacent
			), cells)
		blocked = cat(blocked, check_points, dims=1)
	end
	
	for coor in unique(blocked)
		cells[coor].is_blocked = true
	end

	update_regions!(regions, cells)
end

function smallest_region(regions)
	d = size(regions["rows"], 1)

	region_type = nothing
	min_region = nothing
	min_size = d*d

	for i in 1:d
		row_candidates = regions["rows"][i].candidates
		if 0 < row_candidates < min_size
			region_type = "rows"
			min_region = i
			min_size = row_candidates
		end
		
		col_candidates = regions["cols"][i].candidates
		if 0 < col_candidates < min_size
			region_type = "cols"
			min_region = i
			min_size = col_candidates
		end

		group_candidates = regions["groups"][i].candidates
		if 0 < group_candidates < min_size
			region_type = "groups"
			min_region = i
			min_size = group_candidates
		end
	end

	return min_region, region_type
end

function place_star!(cells::Array{Cell}, regions, normal_select)
	d, n = size(cells)

	idx = nothing
	
	if normal_select
		idx = findfirst(x -> !(x.is_blocked || x.is_star), cells)	
	else
		region, type = smallest_region(regions)
		if type == "rows"
			idx = findfirst(x -> !(x.is_blocked || x.is_star)
				&& x.row == region, cells)
		elseif type == "cols"
			idx = findfirst(x -> !(x.is_blocked || x.is_star)
				&& x.col == region, cells)
		elseif type == "groups"
			idx = findfirst(x -> !(x.is_blocked || x.is_star)
				&& x.group == region, cells)
		end
	end

	if !isnothing(idx)
		cells[idx].is_star = true
		update_regions!(regions, cells)
		return cells[idx]
	end

	# throw(ArgumentError("could not find an available cell"))
	return 
end

struct StarBattleResult
	cells::Union{Nothing, Array{Cell, 2}}
	steps::Int
end

function solve(puzzle::Array{Int, 2}, k::Int; normal_select::Bool=_NORMAL_SELECT, logging::Bool=false)
	d, n = size(puzzle)

	if logging
		println("$k-star $n x $n puzzle")
	end

	regions = Dict{String,Array}(
		"rows" => Vector{Region}(undef, d),
		"cols" => Vector{Region}(undef, d),
		"groups" => Vector{Region}(undef, d),
	)
	cells = Array{Cell}(undef, d, d)
	fill_cells!(cells, puzzle)
	fill_regions!(regions, cells)

	n = Node(data=deepcopy(cells))
	steps = 0
	while true
		steps += 1
		if size(get_stars(cells), 1) == k*d
			return StarBattleResult(cells, steps)
			break
		elseif !illegal(regions, k)
			cell = place_star!(cells, regions, normal_select)
			if !isnothing(cell)
				block!(cells, regions, k)
				insert!(n, cells, cell)
				n = n.children[end]
				cells = deepcopy(n.data)
			else
				return StarBattleResult(nothing, steps)
				break
			end
		elseif !isnothing(n.parent)
			bad_cell = n.cell
			n = n.parent
			delete_children!(n)
			n.data[bad_cell.row, bad_cell.col].is_blocked = true
			n.data[bad_cell.row, bad_cell.col].is_star = false
			cells = deepcopy(n.data)
			update_regions!(regions, cells)
		else
			return StarBattleResult(nothing, steps)
			break
		end
	end
	
	return n.cell
end