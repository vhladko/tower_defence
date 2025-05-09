extends Area3D
class_name Bullet

var speed: float
var damage: float
var target: Node3D

func _physics_process(delta: float) -> void:
	if not is_instance_valid(target):
		queue_free()
		return
	var direction = (target.global_transform.origin - global_transform.origin).normalized()
	global_transform.origin += direction * speed * delta
	

func _on_body_entered(body: Node3D) -> void:
	if body == target and body.has_method("get_hit"):
		body.get_hit(damage)
		queue_free()
