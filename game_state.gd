extends Node

signal game_over

enum UI_MODES {GAME, BUILDING}

var ui_mode: UI_MODES = UI_MODES.GAME
var user_hp: int = 100
var gold: float = 0

func set_ui_mode(mode: UI_MODES) -> void:
	ui_mode = mode

func get_ui_mode() -> UI_MODES:
	return ui_mode

func _game_over():
	emit_signal("game_over")
	_reset_state()

func _reset_state():
	ui_mode = UI_MODES.GAME
	user_hp = 100

func set_user_hp(hp: int) -> void:
	if (hp <= 0):
		user_hp = 0
		_game_over()
		return
	if (hp > 100):
		user_hp = 100
		return
	user_hp = hp
	
func add_gold(gold: float) -> void:
	gold += gold
