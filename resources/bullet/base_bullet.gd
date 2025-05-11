extends Area3D
class_name BaseBullet

@export var bullet_data: BulletData

var speed: float
var damage: float
var target: Node3D
var explosion_prefab: PackedScene
var explosion_lifetime: float = 1.0

func _ready() -> void:
	speed = bullet_data.speed
	damage = bullet_data.damage
	explosion_prefab = bullet_data.particles_prefab
	explosion_lifetime = bullet_data.particles_lifetime
	connect("body_entered", _on_body_entered)

func _physics_process(delta: float) -> void:
	if not is_instance_valid(target):
		queue_free()
		return
	var direction = (target.global_transform.origin - global_transform.origin).normalized()
	global_transform.origin += direction * speed * delta
	

func set_target(new_target: Node3D) -> void:
	target = new_target
	

func _on_body_entered(body: Node3D) -> void:
	if is_instance_valid(target) && body == target && body.has_method("get_hit"):
		body.get_hit(damage)
		var explosion = explosion_prefab.instantiate()
		if explosion is GPUParticles3D:
			get_tree().current_scene.add_child(explosion)
			explosion.global_transform.origin = global_transform.origin
			explosion.emitting = true
		queue_free()
