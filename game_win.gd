extends CanvasLayer

class_name GameWin

func _ready():
	self.hide()
	State.connect("game_win", game_win)

func _on_button_pressed():
	get_tree().paused = false
	get_tree().reload_current_scene()

	
func game_win():
	self.show()
	get_tree().paused = true
