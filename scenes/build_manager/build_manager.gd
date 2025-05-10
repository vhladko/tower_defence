extends Node3D


var _building: PackedScene
var _building_instance: Node3D
var _cam: Camera3D
var _last_valid_location: Vector3
var _last_valid_local_location: Vector3i
var _grid: GridMap
var _can_place: bool

var RAYCAST_LENGTH = 1000.0


func _start_building(building: PackedScene):
	_building_instance = building.instantiate()
	_building = building
	State.set_ui_mode(State.UI_MODES.BUILDING)
	_building_instance.is_ghost = true
	
	add_child(_building_instance)
	_building_instance.visible = false
	_cam = get_viewport().get_camera_3d()

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.pressed:
			place_building()
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_RIGHT:
		if event.pressed:
			cancel_building()

func place_building():
	if _can_place:
		var new_build = _building.instantiate()
		new_build.global_position = _last_valid_location
		_grid.add_child(new_build)
		_grid.place_in_cell(_last_valid_local_location)

func cancel_building():
	State.set_ui_mode(State.UI_MODES.GAME)
	_building_instance.queue_free()

func _physics_process(_delta):
	if State.get_ui_mode() == State.UI_MODES.BUILDING: 
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
				clear_texture_override()
				_grid = col
				var local_coords = col.local_to_map(ray_result.get("position"))
				var global_coords = col.map_to_local(local_coords)
				_building_instance.global_position = global_coords
				_last_valid_location = global_coords
				_last_valid_local_location = local_coords
				var is_good_for_placement = false
				var item = col.get_cell_item(local_coords)
				if item > 0:
					var layers = col.mesh_library.get_item_navigation_layers(item)
					var names = get_navigation_layer_name_from_mask(layers)
					is_good_for_placement = names.filter(func(layout_name): return layout_name == 'building_area').size() > 0
				
				if col.is_cell_occupied(local_coords) || not is_good_for_placement:
					make_building_error()
					_can_place = false
				else:
					make_building_transparent()
					_can_place = true

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

func clear_texture_override():
	var _building_model = _building_instance.get_child(0)
	var _building_mesh = _building_model.get_child(0)
	if _building_mesh is MeshInstance3D:
		_building_mesh.set_surface_override_material(0, null)

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
