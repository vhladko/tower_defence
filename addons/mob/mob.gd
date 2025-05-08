extends CharacterBody3D

@export var healthBarPrefab: PackedScene;
var healthBar: Node2D;

var path: Path3D
var pathFollow: PathFollow3D

var maxHitPoints: float = 100;
var currentHitPoints: float = 60;

var killCost: float;
var speed: float
var size: float;

func _ready() -> void:
	pathFollow = PathFollow3D.new()
	path.add_child(pathFollow)
	global_transform.origin = pathFollow.global_transform.origin
	
	healthBar = healthBarPrefab.instantiate()
	healthBar.maxHealth = maxHitPoints
	add_child(healthBar)
	updateHealthBarPosition()
	

func updateHealthBarPosition() -> void:
	var camera = get_viewport().get_camera_3d()
	var screen_pos = camera.unproject_position(global_transform.origin + Vector3(0, 2, 0)) 
	healthBar.global_position = screen_pos

func updateHealthBar() -> void:
	healthBar.set_health(currentHitPoints);

func _physics_process(delta: float) -> void:
	move_by_path(delta)
	checkProgress()
	updateHealthBar()
	return

func checkProgress() -> void:
	var progressInPercent = pathFollow.progress_ratio * 100
	if progressInPercent > 10.0:
		die()

func move_by_path(delta: float) -> void:
	global_transform.origin = pathFollow.global_transform.origin
	pathFollow.progress += speed * delta
	currentHitPoints = currentHitPoints - delta
	updateHealthBarPosition()
	
func die() ->void:
	queue_free()
