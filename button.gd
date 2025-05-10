extends Button
@export var building: PackedScene
@export var building_icon: Texture2D

func _ready():
	icon = building_icon
	
func _on_button_up():
	BuildManager._start_building(building)
