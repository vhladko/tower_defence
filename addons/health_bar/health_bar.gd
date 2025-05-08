extends Node2D

var maxHealth: float
var currentHealth: float

@export var healthBarProgress: ProgressBar

func _ready() -> void:
	currentHealth = maxHealth
	update_bar()
	
func set_health(health: float) -> void:
	currentHealth = health
	update_bar()

func update_bar() -> void:
	var calculatedValue = (currentHealth /  maxHealth) * 100
	healthBarProgress.value = calculatedValue
	var color = Color.DARK_GREEN
	if(calculatedValue < 50):
		color = Color.YELLOW
	elif(calculatedValue < 20):
		color = Color.RED
	var style = StyleBoxFlat.new()
	style.bg_color = color
	healthBarProgress.add_theme_stylebox_override("fill", style)
	
