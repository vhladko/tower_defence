extends Node3D
class_name MobSpawner

@export var path: Path3D;

var mob_prefab: PackedScene
var spawn_delay: float;
var delay_before_start: float;
var total: int = 0;
var count: int = 0;


func init_wave(wave_data: WaveData) -> void:
	total = wave_data.spawn_amount
	mob_prefab = wave_data.mobs_prefab
	delay_before_start = wave_data.delay_before_start
	spawn_delay = wave_data.spawn_delay
	count = 0
	

func _on_timer_timeout() -> void:
	if count < total:
		if is_instance_valid(mob_prefab):
			var mob = mob_prefab.instantiate()
			if mob is BaseMob:
				mob.init_path(path)
				add_child(mob)
				count += 1
	
