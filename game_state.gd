extends Node

enum UI_MODES {GAME, BUILDING}

var ui_mode: UI_MODES = UI_MODES.GAME
var user_hp: int = 100

func _ready():
	pass

func set_ui_mode(mode: UI_MODES) -> void:
	ui_mode = mode

func get_ui_mode() -> UI_MODES:
	return ui_mode

func set_user_hp(hp: int) -> void:
	if (hp < 0):
		user_hp = 0
		return
	if (hp > 100):
		user_hp = 100
		return
	user_hp = hp
