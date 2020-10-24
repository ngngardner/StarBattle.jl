
using Parameters

mutable struct Region
	candidates::Int
	stars::Int
end

mutable struct Cell
	row::Int
	col::Int
	group::Int
	is_star::Bool
	is_blocked::Bool
end

@with_kw mutable struct Node
	data::Array{Cell, 2}
	cell::Union{Cell, Nothing} = nothing
	parent::Union{Node, Nothing} = nothing
	children::Vector{Node} = []
end

function insert!(n::Node, cells::Array{Cell}, cell::Cell)
	m = Node(data=deepcopy(cells), cell=cell, parent=n)
	push!(n.children, m)
end

function delete_children!(n::Node)
	for child in n.children
		delete_children!(child)
		deleteat!(n.children, findall(x->x == child, n.children))
	end
end
