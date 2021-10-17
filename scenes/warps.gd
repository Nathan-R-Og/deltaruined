extends Node2D

onready var player = $"/root/World/Objects/Player"
onready var objects = $"/root/World/Objects"
export var warps = []
export var links = []
export var newExits = 0


func _ready():
	connectZones()
	
	if data.lastZone != -1:
		var what = links.find(data.lastZone)
		player.directionality()
		player.position = get_child(what).get_node("LoadPlace").global_position
		player.runTimer = data.lastTimer
		data.lastZone = -1
		data.lastDir = []


func connectZones():
	var iterate = 0
	while iterate <= get_child_count() -1:
		get_child(iterate).connect("body_entered", self, "loadingZone", [links[iterate], iterate])
		iterate += 1


func loadingZone(body, link, index):
	if body.name == "Player":
		data.lastZone = link
		data.lastDir.insert(0,player.direction)
		data.lastTimer = player.runTimer
		get_tree().change_scene(warps[index])
