extends Node


var stateArrayA = []
var stateArrayB = []


# Called when the node enters the scene tree for the first time.
func _ready():
	pass
	#_cacheStates()

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass



func _cacheStates():
	var iterateChildren = 0
	while iterateChildren < $"../World/Objects".get_child_count():
		var getNode = $"../World/Objects".get_child(iterateChildren)
		if getNode.name != "Player":
			stateArrayA.append([getNode, ""])
		iterateChildren += 1
