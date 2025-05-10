extends GridMap

var occupied_cells := {}

func place_in_cell(cell: Vector3i) -> void:
	occupied_cells[cell] = true

func is_cell_occupied(cell: Vector3i) -> bool:
	return occupied_cells.has(cell)
