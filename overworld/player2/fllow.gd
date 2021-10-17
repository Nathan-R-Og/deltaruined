extends KinematicBody2D


export var record = 0
var tween = Tween.new()
var tweenSpd = 0.017 * 3
var distanceMax = 80.0
export var MainPath = NodePath()
onready var Main = get_node(MainPath)
export var TweenNode = NodePath()
onready var TweenNoder = get_node(TweenNode)

var tweenIng = false
var tweenAllow = false

var baseInc = 4
var inc = baseInc

var storeDist = Vector2()

var readY = false


func _ready():
	add_child(tween)

func _process(delta):
	if Main != null:
		readY = true


	if readY == true:
		var distance = Vector2()
		distance.x = abs(position.x - Main.recordX[record])
		distance.y = abs(position.y - Main.recordY[record])
		var posX = Main.recordX[record]
		var posY = Main.recordY[record]
		var Pos = Vector2(posX,posY)

		if position != Vector2(posX, posY) and Main.moving == true:
			if distance.x > distanceMax or distance.y > distanceMax and tweenAllow == true:
				storeDist = position - TweenNoder.position
				tweenIng = true
				tween.interpolate_property(self, "position:x",
						position.x, position.x - (storeDist.x / 4), tweenSpd,
						Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
				tween.start()
				tween.interpolate_property(self, "position:y",
						position.y, position.y - (storeDist.y / 4), tweenSpd,
						Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
				tween.start()
				yield(get_tree().create_timer(tweenSpd),"timeout")
				storeDist = Vector2()
				tweenIng = false
			if distance <= Vector2(distanceMax, distanceMax) and tweenIng == false:
				tweenAllow = false
				position = Pos
