extends Node3D


@export var mob_spawner: MobSpawner

@export var waves: Array[WaveData]

func _ready() -> void:
	if is_instance_valid(mob_spawner):
		mob_spawner.init_wave(waves[0])
