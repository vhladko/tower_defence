extends Button
@export var building: PackedScene
@export var building_icon: Texture2D
@export var main: Node3D

var _is_dragging: bool = false
var _building_instance: Node3D
var _cam: Camera3D
var _last_valid_location: Vector3

var RAYCAST_LENGTH = 1000.0

func _ready():
	icon = building_icon
	_building_instance = building.instantiate()
	add_child(_building_instance)
	_building_instance.visible = false
	_cam = get_viewport().get_camera_3d()
	

func _on_button_down():
	_is_dragging = true


func _on_button_up():
	_is_dragging = false
	_building_instance.visible = false
	var new_build = building.instantiate()
	new_build.global_position = _last_valid_location
	main.add_child(new_build)

func _physics_process(_delta):
	if _is_dragging:
		var space_state = _building_instance.get_world_3d().direct_space_state
		var mouse_position = get_viewport().get_mouse_position()
		var origin = _cam.project_ray_origin(mouse_position)
		var end = origin + _cam.project_ray_normal(mouse_position) * RAYCAST_LENGTH
		var query: PhysicsRayQueryParameters3D = PhysicsRayQueryParameters3D.create(origin, end)
		query.collide_with_areas = true
		query.collide_with_bodies = true
		query.collision_mask = 2
		var ray_result = space_state.intersect_ray(query)
		if ray_result.size() > 0:
			_building_instance.visible = true
			var col = ray_result.get('collider')
			if col is GridMap:
				var local_coords = col.local_to_map(ray_result.get("position"))
				var global_coords = col.map_to_local(local_coords)
				var used_cells = col.get_used_cells()
				_building_instance.global_position = global_coords
				_last_valid_location = global_coords
		else:
			_building_instance.global_position = Vector3(mouse_position.x, 0.2, mouse_position.y)
