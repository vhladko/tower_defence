extends Node3D


enum UI_MODE {BUILDING, NONE}

var ui_mode: UI_MODE = UI_MODE.NONE

func change_mode(mode: UI_MODE) -> void:
  ui_mode = mode
