
include("struct.jl")

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
		
		# adjacent
		check_points = findall(a -> sqrt((a.row - b.row)^2+(a.col - b.col)^2) < 2, cells)
		for p in check_points
			if p ∉ blocked
				push!(blocked, p)
			end
		end
		
		# rows
		if regions["rows"][b.row].stars ≥ k
			check_points = findall(a -> a.row == b.row, cells)
			for p in check_points
				if p ∉ blocked
					push!(blocked, p)
				end
			end
		end
		
		# columns
		if regions["cols"][b.col].stars ≥ k
			check_points = findall(a -> a.col == b.col, cells)
			for p in check_points
				if p ∉ blocked
					push!(blocked, p)
				end
			end
		end

		# groups
		if regions["groups"][b.group].stars ≥ k
			check_points = findall(a -> a.group == b.group, cells)
			for p in check_points
				if p ∉ blocked
					push!(blocked, p)
				end
			end
		end
	end
	
	for coor in blocked
		if !cells[coor].is_star
			cells[coor].is_blocked = true
		end
	end

	update_regions!(regions, cells)
end

function place_star!(cells::Array{Cell}, regions)
	d, n = size(cells)
	
	idx = findfirst(x -> !(x.is_blocked || x.is_star), cells)

	if !isnothing(idx)
		cells[idx].is_star = true
		update_regions!(regions, cells)
		return cells[idx]
	end

	throw(ArgumentError("could not find an available cell"))
	return 
end

function solve(puzzle, k; logging::Bool=false)
	d, n = size(puzzle)

	if logging
		println("$k-star $n x $n puzzle")
	end

	cells = Array{Cell}(undef, d, d)
	regions = Dict{String,Array}(
		"rows" => Vector{Region}(undef, d),
		"cols" => Vector{Region}(undef, d),
		"groups" => Vector{Region}(undef, d),
	)
	
	fill_cells!(cells, puzzle)
	fill_regions!(regions, cells)

	n = Node(data=deepcopy(cells))
	steps = 0
	while true
		steps += 1
		if size(get_stars(cells), 1) == k*d
			if logging
				println("found solution in $steps steps")
			end
			return cells
			break
		elseif !illegal(regions, k)
			cell = place_star!(cells, regions)
			block!(cells, regions, k)
			insert!(n, cells, cell)
			n = n.children[end]
			cells = deepcopy(n.data)
		elseif !isnothing(n.parent)
			bad_cell = n.cell
			n = n.parent
			delete_children!(n)
			n.data[bad_cell.row, bad_cell.col].is_blocked = true
			n.data[bad_cell.row, bad_cell.col].is_star = false
			cells = deepcopy(n.data)
			update_regions!(regions, cells)
		else
			if logging
				println("found solution in $steps steps")
			end
			return cells
			break
		end
	end
	
	return n.cell
end