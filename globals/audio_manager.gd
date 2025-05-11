extends Node

var sound_players = []

func play_sound(sound_path: String, volume: float = 1.0, pitch: float = 1.0) -> void:
	var player = AudioStreamPlayer3D.new()
	player.stream = load(sound_path)
	player.volume_db = 20 * log(volume)
	player.pitch_scale = pitch
	add_child(player)
	player.play()
	
	
	player.connect("finished", _on_sound_finished)
	sound_players.append(player)

func _on_sound_finished(player: AudioStreamPlayer3D) -> void:
	print(player)
	if player in sound_players:
		sound_players.erase(player)
		player.queue_free()
