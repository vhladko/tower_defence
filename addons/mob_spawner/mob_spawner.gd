extends Node3D

@export var mob_prefab: PackedScene;

@export var path: Path3D;

var count: int = 0;
var total: int = 10;

func _on_timer_timeout() -> void:
	if count < total:
		var mob = mob_prefab.instantiate()
		mob.path = path
		mob.speed = 2.0
		add_child(mob)
		count += 1
	
