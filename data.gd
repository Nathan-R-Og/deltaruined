extends Node


var lastZone = -1
var lastDir = []
var lastTimer = 0.0




var stateArrayA = []
var stateArrayB = []


#to convserve object states on exit of scenes and game

func _cacheStates():
	var iterateChildren = 0
	while iterateChildren < $"../World/Objects".get_child_count():
		var getNode = $"../World/Objects".get_child(iterateChildren)
		if getNode.name != "Player":
			stateArrayA.append([getNode, ""])
		iterateChildren += 1
