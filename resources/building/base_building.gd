extends Node3D
class_name BaseBuilding

@export var building_data: BuildingData

var bullet_prefab: PackedScene
var fire_rate: float
var _is_selected: bool = false
var _cam: Camera3D

var is_ghost: bool = false
var mobs_in_range = []

func _ready() -> void:
	_cam = get_viewport().get_camera_3d()
	bullet_prefab = building_data.bullet_prefab
	fire_rate = building_data.fire_rate
	var attack_range = create_attack_range(building_data.attack_range_radius)
	add_child(attack_range)
	
	var timer = Timer.new()
	timer.wait_time = fire_rate
	timer.autostart = true
	add_child(timer)
	timer.connect("timeout", _on_timer_timeout)

func _input(event):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		var space_state = get_tree().get_root().get_world_3d().direct_space_state
		var mouse_position = get_viewport().get_mouse_position()
		var origin = _cam.project_ray_origin(mouse_position)
		var end = origin + _cam.project_ray_normal(mouse_position) * 1000
		var query: PhysicsRayQueryParameters3D = PhysicsRayQueryParameters3D.create(origin, end)
		query.collide_with_areas = true
		query.collide_with_bodies = true
		query.collision_mask = 8
		var ray_result = space_state.intersect_ray(query)
		if ray_result.size() > 0:
			var col = ray_result.get('collider')
			if col is StaticBody3D:
				_is_selected = is_ancestor_of(col)


func _on_timer_timeout():
	if not is_ghost:
		attack()

func create_attack_range(radius: float) -> Area3D:
	var attack_range = Area3D.new()
	
	var collision_shape = CollisionShape3D.new()
	var sphere_shape = SphereShape3D.new()
	sphere_shape.radius = radius
	collision_shape.shape = sphere_shape
	
	attack_range.add_child(collision_shape)
	
	attack_range.collision_layer = (1 << 0) | (1 << 2)
	attack_range.collision_mask = 1
	
	attack_range.connect("body_entered", _on_attack_range_body_entered)
	attack_range.connect("body_exited", _on_attack_range_body_exited)
	
	return attack_range


func _on_attack_range_body_entered(body: Node3D) -> void:
	if body.has_method("get_hit"):
		mobs_in_range.append(body);

func _on_attack_range_body_exited(body: Node3D) -> void:
	if body in mobs_in_range:
		mobs_in_range.erase(body)

func attack():
	if mobs_in_range.size() == 0:
		return
	mobs_in_range.sort_custom(_sort_by_distance)
	var target = mobs_in_range[0]
	if is_instance_valid(target):
		var bullet = bullet_prefab.instantiate()
		if bullet is BaseBullet:
			bullet.set_target(target)
			add_child(bullet)
			bullet.global_transform.origin = bullet.global_transform.origin + Vector3(0, 3, 0)


func _sort_by_distance(a, b):
	return a.pathFollow.progress > b.pathFollow.progress

func check_selection():
	var space_state = get_tree().get_root().get_world_3d().direct_space_state
	var mouse_position = get_viewport().get_mouse_position()
	var origin = _cam.project_ray_origin(mouse_position)
	var end = origin + _cam.project_ray_normal(mouse_position) * 1000
	var query: PhysicsRayQueryParameters3D = PhysicsRayQueryParameters3D.create(origin, end)
	query.collide_with_areas = true
	query.collide_with_bodies = true
	query.collision_mask = 8
	var ray_result = space_state.intersect_ray(query)
	if ray_result.size() > 0:
		var col = ray_result.get('collider')
		if col is StaticBody3D:
			_is_selected = is_ancestor_of(col)
