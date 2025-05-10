extends Node3D
class_name MobSpawner

signal wave_spawn_finished

@export var path: Path3D;

var mob_prefab: PackedScene
var spawn_delay: float;
var delay_before_start: float;
var total: int = 0;
var count: int = 0;

var delay_before_start_timer: Timer
var timer: Timer

func init_wave(wave_data: WaveData) -> void:
	total = wave_data.spawn_amount
	mob_prefab = wave_data.mobs_prefab
	delay_before_start = wave_data.delay_before_start
	spawn_delay = wave_data.spawn_delay
	count = 0
	
	delay_before_start_timer = Timer.new()
	delay_before_start_timer.wait_time = delay_before_start
	delay_before_start_timer.autostart = true
	add_child(delay_before_start_timer)
	delay_before_start_timer.connect('timeout', start_spawn)


func start_spawn() -> void:
	timer = Timer.new()
	timer.wait_time = spawn_delay
	timer.autostart = true
	add_child(timer)
	timer.connect("timeout", spawn_mob)
	delay_before_start_timer.queue_free()

func spawn_mob() -> void:
	if count < total:
		if is_instance_valid(mob_prefab):
			var mob = mob_prefab.instantiate()
			if mob is BaseMob:
				mob.init_path(path)
				add_child(mob)
				count += 1
	elif count == total:
		emit_signal("wave_spawn_finished")
		timer.queue_free()
