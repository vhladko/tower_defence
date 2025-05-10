extends BaseBullet

@export var splash_radius: float

var mobs_to_hit: Array[Node3D]
var splash_area: Area3D

func _ready() -> void:
	super()
	splash_area = create_splash_area()
	splash_area.global_transform.origin = global_transform.origin
	add_child(splash_area)

func create_splash_area() -> Area3D:
	var splash_area = Area3D.new()
	
	var collision_shape = CollisionShape3D.new()
	var sphere_shape = SphereShape3D.new()
	print(splash_radius)
	sphere_shape.radius = splash_radius
	collision_shape.shape = sphere_shape
	
	splash_area.add_child(collision_shape)
	
	splash_area.collision_layer = 1
	splash_area.collision_mask = 3
	
	splash_area.connect("body_entered",  _on_splash_area_entered)
	splash_area.connect("body_exited",  _on_splash_area_exited)
	
	return splash_area

func _physics_process(delta: float) -> void:
	super(delta)
	splash_area.global_transform.origin = global_transform.origin
	

func check_is_mob(body: Node3D) -> bool:
	return is_instance_valid(body) && body.has_method("get_hit")

func splash_attack() -> void:
		for body in mobs_to_hit:
			body.get_hit(damage);

func _on_splash_area_entered(body: Node3D):
	if check_is_mob(body):
		mobs_to_hit.append(body)

func _on_splash_area_exited(body: Node3D):
	if check_is_mob(body) && body in mobs_to_hit:
		mobs_to_hit.erase(body)
		

func _on_body_entered(body: Node3D) -> void:
	if is_instance_valid(target) && body == target && body.has_method("get_hit"):
		splash_attack()
		queue_free()
