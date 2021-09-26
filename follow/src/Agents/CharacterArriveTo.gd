extends KinematicBody2D


onready var sprite: Sprite = $TriangleRed
onready var camera: Camera2D = $Camera2D

const DISTANCE_THRESHOLD: = 3.0

export var max_speed: = 500.0

var target_global_position: = Vector2.ZERO setget set_target_global_position
var _velocity: = Vector2.ZERO

var CharVel = Vector2()


var _is_following: = false


func _ready() -> void:
	set_physics_process(false)

func _process(delta):
	CharVel.x = (Input.get_action_strength("move_right")-Input.get_action_strength("move_left")) * 320
	CharVel.y = (Input.get_action_strength("move_down")-Input.get_action_strength("move_up")) * 320
	CharVel = move_and_slide(CharVel)
	sprite.rotation = CharVel.angle()



func set_target_global_position(value: Vector2) -> void:
	target_global_position = value
	camera.global_position = value
	set_physics_process(true)
