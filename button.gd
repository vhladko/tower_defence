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
	_building_instance.is_ghost = true
	
			
	add_child(_building_instance)
	_building_instance.visible = false
	_cam = get_viewport().get_camera_3d()
	

func _on_button_down():
	_is_dragging = true
	make_building_transparent()


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
		query.collide_with_bodies = true
		query.collision_mask = 2
		var ray_result = space_state.intersect_ray(query)
		if ray_result.size() > 0:
			_building_instance.visible = true
			var col = ray_result.get('collider')
			if col is GridMap:
				var local_coords = col.local_to_map(ray_result.get("position"))
				var global_coords = col.map_to_local(local_coords)
				var item = col.get_cell_item(local_coords)
				_building_instance.global_position = global_coords
				_last_valid_location = global_coords
				if item > 0:
					var layers = col.mesh_library.get_item_navigation_layers(item)
					var names = get_navigation_layer_name_from_mask(layers)

		else:
			_building_instance.global_position = Vector3(mouse_position.x, 0.2, mouse_position.y)

func get_navigation_layer_name_from_mask(mask: int) -> Array:
	var names := []
	for i in 32:
		if mask & (1 << i) != 0:
			var layer_idx = i + 1
			var setting = "layer_names/3d_navigation/layer_%d" % layer_idx
			var layer_name = ProjectSettings.get(setting)
			if layer_name == "":
				layer_name = "Layer %d" % layer_idx
			names.append(layer_name)
	return names

func make_building_transparent():
	var _building_model = _building_instance.get_child(0)
	var _building_mesh = _building_model.get_child(0)
	if _building_mesh is MeshInstance3D:
		var mat = _building_mesh.get_active_material(0)
		if mat == null:
			mat = StandardMaterial3D.new()
		else:
			mat = mat.duplicate()

		_building_mesh.set_surface_override_material(0, mat)
		mat.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA
		mat.blend_mode = BaseMaterial3D.BLEND_MODE_ADD

		var c: Color = mat.albedo_color
		c.a = 0.2
		mat.albedo_color = c

func make_building_error():
	var _building_model = _building_instance.get_child(0)
	var _building_mesh = _building_model.get_child(0)
	if _building_mesh is MeshInstance3D:
		var mat = _building_mesh.get_active_material(0)
		if mat == null:
			mat = StandardMaterial3D.new()
		else:
			mat = mat.duplicate()

		_building_mesh.set_surface_override_material(0, mat)
		mat.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA
		mat.blend_mode = BaseMaterial3D.BLEND_MODE_ADD

		var c: Color = mat.albedo_color
		c.a = 0.3
		c.r = 1
		c.b = 0
		c.g = 0
		mat.albedo_color = c
