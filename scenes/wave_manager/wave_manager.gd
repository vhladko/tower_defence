extends Node3D


@export var mob_spawner: MobSpawner

@export var waves: Array[WaveData]

var wave_index: int = 0;
var wave_started_spawn_index: int = 0

func _ready() -> void:
	set_wave()

func check_win():
	var children = mob_spawner.get_children().filter(func(child): return child is BaseMob)
	print(children.size(), wave_index, wave_started_spawn_index)
	if children.size() == 0 && wave_index >= waves.size() && wave_started_spawn_index >= waves.size():
		State.waves_finished()

func _on_mob_spawner_wave_spawn_finished() -> void:
	wave_index += 1
	set_wave()

func set_wave() -> void:
	print(wave_index, waves.size())
	if is_instance_valid(mob_spawner) && wave_index < waves.size():
		mob_spawner.init_wave(waves[wave_index])


func _on_mob_spawner_child_order_changed():
	check_win()


func _on_mob_spawner_wave_spawn_start() -> void:
	wave_started_spawn_index += 1
