extends CharacterBody3D
class_name BaseMob

@export var healthBarPrefab: PackedScene;
@export var mob_data: MobData
var healthBar: Node2D;
var damage: int = 1

var pathFollow: PathFollow3D

var max_hit_points: float;
var current_hit_points: float;

var reward: float
var speed: float

func _ready() -> void:
	max_hit_points = mob_data.health
	current_hit_points = mob_data.health
	reward = mob_data.reward
	speed = mob_data.speed
	
	healthBar = healthBarPrefab.instantiate()
	healthBar.maxHealth = max_hit_points
	add_child(healthBar)
	update_health_bar_position()

func init_path(path: Path3D) -> void:
	pathFollow = PathFollow3D.new()
	path.add_child(pathFollow)
	global_transform.origin = pathFollow.global_transform.origin
	update_health_bar_position()

func update_health_bar_position() -> void:
	var camera = get_viewport().get_camera_3d()
	var screen_pos = camera.unproject_position(global_transform.origin + Vector3(0, 2, 0))
	healthBar.global_position = screen_pos

func updateHealthBar() -> void:
	healthBar.set_health(current_hit_points);

func _physics_process(delta: float) -> void:
	move_by_path(delta)
	checkProgress()
	updateHealthBar()
	return

func checkProgress() -> void:
	var progressInPercent = pathFollow.progress_ratio * 100
	

func move_by_path(delta: float) -> void:
	global_transform.origin = pathFollow.global_transform.origin
	pathFollow.progress += speed * delta
	update_health_bar_position()

func get_hit(damage: float):
	current_hit_points -= damage
	updateHealthBar()
	if current_hit_points <= 0:
		die()
	
func die() -> void:
	queue_free()
