extends Button
@export var building: PackedScene
@export var building_icon: Texture2D

var _is_dragging: bool = false
var _building_instance: Node3D
var _cam: Camera3D

var RAYCAST_LENGTH = 100.0

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

func _physics_process(_delta):
	if _is_dragging:
		var space_state = _building_instance.get_world_3d().direct_space_state
		var mouse_position = get_viewport().get_mouse_position()
		var origin = _cam.project_ray_origin(mouse_position)
		var end = origin + _cam.project_ray_normal(mouse_position) * RAYCAST_LENGTH
		var query: PhysicsRayQueryParameters3D = PhysicsRayQueryParameters3D.create(origin, end)
		query.collide_with_areas = true
		var ray_result = space_state.intersect_ray(query)
		print(ray_result.size())
		if ray_result.size() > 0:
			var col = ray_result.get('collider')
			print(col)
