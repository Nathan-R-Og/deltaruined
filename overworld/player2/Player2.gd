
extends KinematicBody2D



"""
Character that follows the mouse constantly
Uses the follow steering behavior
"""


onready var sprite = $PlayerSprite
onready var target = get_node(target_path)
onready var follow_hint = $FollowHint

const ARRIVE_THRESHOLD = 100.0

export var max_speed = 750.0
export var target_path = NodePath()
export var follow_offset = 100.0

var _velocity = Vector2.ZERO


var direction = ""

func _ready():
	follow_hint.set_as_toplevel(true)


func _physics_process(delta) -> void:
	var target_global_position = Vector2()
	if target != self:
		target_global_position = target.global_position 
	else:
		target_global_position = get_global_mouse_position()

	var to_target = global_position.distance_to(target_global_position)
	if to_target < ARRIVE_THRESHOLD:
		return

	var follow_global_position = Vector2()
	if to_target > follow_offset:
		follow_global_position = target_global_position - (target_global_position - global_position).normalized() * (follow_offset)
	else:
		follow_global_position = global_position


	_velocity = Steering.arrive_to(
		_velocity,
		global_position,
		follow_global_position,
		max_speed,
		200.0,
		10.0
	)
	_velocity = move_and_slide(_velocity)
	var animateAngle = _velocity.angle()
	var pushVector = Vector2(cos(animateAngle),sin(animateAngle))
	pushVector.x = round(pushVector.x)
	pushVector.y = round(pushVector.y)


	if pushVector.x > 0 and pushVector.y > 0:
		if pushVector.x == pushVector.y:
			direction = "downRight"
		if pushVector.x > pushVector.y:
			direction = "right"
		if pushVector.x < pushVector.y:
			direction = "down"
	if pushVector.x < 0 and pushVector.y > 0:
		if -pushVector.x == pushVector.y:
			direction = "downLeft"
		if -pushVector.x > pushVector.y:
			direction = "left"
		if -pushVector.x < pushVector.y:
			direction = "down"
	if pushVector.x < 0 and pushVector.y < 0:
		if -pushVector.x == -pushVector.y:
			direction = "upLeft"
		if -pushVector.x > -pushVector.y:
			direction = "left"
		if -pushVector.x < -pushVector.y:
			direction = "up"
	if pushVector.x > 0 and pushVector.y < 0:
		if pushVector.x == -pushVector.y:
			direction = "upRight"
		if pushVector.x > -pushVector.y:
			direction = "right"
		if pushVector.x < -pushVector.y:
			direction = "up"
	if pushVector.x > 0 and pushVector.y == 0:
		direction = "right"
	if pushVector.x < 0 and pushVector.y == 0:
		direction = "left"
	if pushVector.x == 0 and pushVector.y > 0:
		direction = "down"
	if pushVector.x == 0 and pushVector.y < 0:
		direction = "up"

		
	$PlayerSprite.play(direction) == direction

	print(direction)
