extends CanvasLayer

class_name GameOver

func _ready():
	self.hide()
	State.connect("game_over", game_over)

func _on_button_pressed():
	get_tree().paused = false
	get_tree().reload_current_scene()

	
func game_over():
	self.show()
	get_tree().paused = true
