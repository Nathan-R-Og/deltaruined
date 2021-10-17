extends Camera2D

var followingPlayer = true
var followMode = 0
var windowWidth = ProjectSettings.get_setting("display/window/size/width")
var windowHeight = ProjectSettings.get_setting("display/window/size/height")
onready var player1 = $"/root/World/Objects/Player"

func _ready():
	zoom.x =  1.0 / (windowWidth / 640.0)
	zoom.y =  1.0 / (windowHeight / 480.0)


func _process(delta):


	var player1Null = player1.get_path()
	if get_node_or_null(player1Null) != null:
		if followingPlayer == true:
			match followMode:
				0:
					var cameraEnd = $"../cameraEnd".position
					var cameraStart = $"../cameraStart".position
					var offsetCamera = Vector2(640,480)/2
					# i swear this worked before
					position.x = clamp(player1.position.x, cameraStart.x + offsetCamera.x, cameraEnd.x - offsetCamera.x)
					position.y = clamp(player1.position.y, cameraStart.y + offsetCamera.y, cameraEnd.y - offsetCamera.y)
