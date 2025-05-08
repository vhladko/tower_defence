extends Node3D

@export var cell_size: float = 2.0

var occupied_cells := {}

func reserve_cell(cell: Vector2i) -> void:
	occupied_cells[cell] = true

func can_build(cell: Vector2i) -> bool:
	return occupied_cells.has(cell)

func get_cell_from_world(pos: Vector3) -> Vector2i:
	return Vector2i(
		int(floor(pos.x / cell_size)),
		int(floor(pos.z / cell_size))
	)
