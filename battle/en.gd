extends Path2D


# Declare member variables here. Examples:
var walkSpeed = 200
var velocity = Vector2()
var steps = 160
var playerPos = Vector2()

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _process(delta):
	$PathFollow2D.unit_offset = 0.5
	var what = $"../pla".position
	var huh = $PathFollow2D.position
	var distance =  what - huh 
	distance.x = abs(distance.x)
	distance.y = abs(distance.y)
	if distance.x >= 48 or distance.y >= 48:
		#how many steps behind it should be
		if curve.get_point_count() > steps:
			curve.remove_point(0)
		
		curve.add_point($"../pla".position - $PathFollow2D/en.position)
