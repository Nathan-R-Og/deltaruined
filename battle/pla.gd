extends KinematicBody2D


# Declare member variables here. Examples:
var walkSpeed = 200
var velocity = Vector2()

export var movementType = 0



func _process(delta):
	match movementType:
		1:
			velocity.x = (Input.get_action_strength("move_right") - Input.get_action_strength("move_left")) * walkSpeed
			velocity.y = (Input.get_action_strength("move_down") - Input.get_action_strength("move_up")) * walkSpeed
			velocity = move_and_slide_with_snap(velocity, Vector2.DOWN, Vector2.UP)
