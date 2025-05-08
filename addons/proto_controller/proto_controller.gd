# ProtoController v1.0 by Brackeys
# CC0 License
# Intended for rapid prototyping of first-person games.
# Happy prototyping!

extends CharacterBody3D

@export_group("Speeds")
@export var look_speed : float = 0.002
@export var base_speed : float = 25.0


@export_group("Input Actions")
@export var input_left : String = "ui_left"
@export var input_right : String = "ui_right"
@export var input_forward : String = "ui_up"
@export var input_back : String = "ui_down"
@export var zoom_out : String = "zoom_out"
@export var zoom_in	: String = "zoom_in"

var look_rotation : Vector2
var move_speed : float = 0.0
var freeflying : bool = true

@onready var head: Node3D = $Head
@onready var collider: CollisionShape3D = $Collider
@onready var mousePosition: Vector2 = get_viewport().get_mouse_position()

func _ready() -> void:
	look_rotation.y = rotation.y
	look_rotation.x = head.rotation.x

func _unhandled_input(event: InputEvent) -> void:
	# Захват мыши при нажатии
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_MIDDLE:
		if event.pressed:
			capture_mouse()
		else:
			release_mouse()
	
	# Обработка движения мыши
	if Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED and event is InputEventMouseMotion:
		rotate_look(event.relative)

	if Input.is_action_pressed(zoom_in):
		handle_zoom_in()
	if Input.is_action_just_pressed(zoom_out):
		handle_zoom_out()


func _physics_process(delta: float) -> void:
	var input_dir := Input.get_vector(input_left, input_right, input_forward, input_back)
	var motion := (head.global_basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	motion *= base_speed * delta
	move_and_collide(motion)
	return
	
func handle_zoom_out() -> void:
	var next_y = position.y + look_speed
	if next_y > 50:
		return
	var motion := (head.global_basis * Vector3(0, look_speed, 0)).normalized()
	move_and_collide(motion)
	return
	
func handle_zoom_in() -> void:
	var next_y = position.y -look_speed

	if next_y < 10:
		return;
	var motion := (head.global_basis * Vector3(0, -look_speed, 0)).normalized()
	move_and_collide(motion)
	return

func rotate_look(rot_input : Vector2):
	look_rotation.y -= rot_input.x * look_speed
	transform.basis = Basis()
	rotate_y(look_rotation.y)
	return
	

func capture_mouse():
	mousePosition = get_viewport().get_mouse_position()
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)


func release_mouse():
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	Input.warp_mouse(mousePosition)
