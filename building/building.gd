extends Node3D
class_name Building

@export var bullet_prefab: PackedScene
var bullet_speed: float = 5.0
var bullet_damage: float = 10.0

var is_ghost: bool = false

var mobs_in_range = []
var fire_rate: float = 1

func _ready() -> void:
	var timer = Timer.new()
	timer.wait_time = fire_rate
	timer.autostart = true
	add_child(timer)
	timer.connect("timeout", _on_timer_timeout)

func _on_timer_timeout():
	if not is_ghost:
		attack()

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
		bullet.speed = bullet_speed
		bullet.damage = bullet_damage
		bullet.target = target
		bullet.global_transform.origin = bullet.global_transform.origin + Vector3(0, 3, 0)
		add_child(bullet)


func _sort_by_distance(a, b):
	return a.pathFollow.progress > b.pathFollow.progress
