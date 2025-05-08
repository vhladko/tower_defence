extends Node3D

@export var ghost_scene: PackedScene
var ghost: Area3D
var active_building_area: Area3D
var hover_cell: Vector2i

func _ready():
	ghost = ghost_scene.instantiate() as Area3D
	add_child(ghost)
	ghost.connect("on_active_building_area", _on_active_building_area)

func _on_active_building_area(active_area: Area3D):
	active_building_area = active_area
	print('active changed', active_area)

	if not active_area:
		ghost.get_child(0).get_active_material(0).albedo_color = Color(1, 0, 0, 0.5)
	else:
		ghost.get_child(0).get_active_material(0).albedo_color = Color(0, 1, 0, 0.5)
