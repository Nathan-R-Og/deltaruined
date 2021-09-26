extends CanvasLayer


var branch = ""
var stringName = ""


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func readyTextStuff(nodeAccess):
	var iterateChildren = 0
	while iterateChildren < data.stateArrayA.size():
		var getNode = data.stateArrayA[iterateChildren][0]
		if getNode == nodeAccess:
			branch = data.stateArrayA[iterateChildren][1]
			break
		iterateChildren += 1
	stringName = nodeAccess.name + branch
	$TextStuff._doTextStuff(stringName, "res://scenes/eart/text/")

func _on_TextStuff_doClose():
	if stringName != "":
		$TextStuff._defaultClose()
		$"/root/World/Objects/Player".doing = false
