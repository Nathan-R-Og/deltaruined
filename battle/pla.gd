extends KinematicBody2D


# Declare member variables here. Examples:
var walkSpeed = 200
var velocity = Vector2()


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _process(delta):
	velocity.x = (Input.get_action_strength("move_right") - Input.get_action_strength("move_left")) * walkSpeed
	velocity.y = (Input.get_action_strength("move_down") - Input.get_action_strength("move_up")) * walkSpeed
	velocity = move_and_slide_with_snap(velocity, Vector2.DOWN, Vector2.UP)
