extends Panel

@onready var cost_label = get_node("Cost")
@onready var name_label = get_node("Name")
@onready var damage_label = get_node("Damage")

func _ready():
	visible = false

func select_tower(cost: float, damage: float, tower_name: String):
	cost_label.text = 'Cost: %d' % cost
	damage_label.text = 'Damage: %d' % damage
	name_label.text = 'Name: %s' % tower_name
	visible = true

func unselect_tower():
	visible = false
