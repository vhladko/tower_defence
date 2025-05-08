extends Area3D

signal on_active_building_area(floor: Area3D)
@export var ground_height: float = 0.0

@export var building_areas_group = 'building_area'
var active_area: Area3D

func _physics_process(_delta: float) -> void:
	if Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
		self.visible = false;
		return
	else:
		self.visible = true

	var cam = get_viewport().get_camera_3d()
	if not cam:
		return
	var mouse_position = get_viewport().get_mouse_position()
	var from = cam.project_ray_origin(mouse_position)
	var dir  = cam.project_ray_normal(mouse_position)
	var plane = Plane(Vector3.UP, ground_height)
	var world_pos = plane.intersects_ray(from, dir)
	if world_pos:
		position = world_pos
		position.y = 0

func _on_area_entered(area: Area3D) -> void:
	if area.is_in_group(building_areas_group):
		active_area = area
		emit_signal("on_active_building_area", area)


func _on_area_exited(area: Area3D) -> void:
	if area.is_in_group(building_areas_group):
		if active_area == area:
			emit_signal("on_active_building_area", null)
			active_area = null
