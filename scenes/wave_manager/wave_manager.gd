extends Node3D


@export var mob_spawner: MobSpawner

@export var waves: Array[WaveData]

var wave_index: int = 0;

func _ready() -> void:
	set_wave()


func _on_mob_spawner_wave_spawn_finished() -> void:
	wave_index += 1
	set_wave()
	
func set_wave() -> void:
	if is_instance_valid(mob_spawner) && wave_index < waves.size():
		mob_spawner.init_wave(waves[wave_index])
