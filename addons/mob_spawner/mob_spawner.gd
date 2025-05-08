extends Node3D

@export var mob_prefab: PackedScene;

@export var path: Path3D;

func _on_timer_timeout() -> void:
	var mob = mob_prefab.instantiate()
	mob.path = path
	mob.speed = 2.0
	add_child(mob)
	
