extends Node2D


export var delay = 0.5

var timerTill = 0.0


var barInst = preload("res://battle/battleAsset/playerFLASHBAR.tscn")

func _process(delta):
	timerTill += delta
	if timerTill >= delay:
		timerTill = 0.0
		var left = barInst.instance()
		var right = barInst.instance()
		add_child(left)
		left.get_node("AnimationPlayer").play("left")
		add_child(right)
		right.get_node("AnimationPlayer").play("right")


	var i = 0
	while i < get_child_count():
		if get_child(i).get_node("AnimationPlayer").is_playing() != true:
			get_child(i).queue_free()
		i += 1
