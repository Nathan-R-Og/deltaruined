extends Node


export var branch = ""
export var stringName = ""
onready var textStuff = $"/root/World/Hud/TextStuff"


func _ready():
	if textStuff != null:
		textStuff.connect("doClose", self, "_on_TextStuff_doClose")

func readyTextStuff(nodeAccess := self):
	var iterateChildren = 0
	while iterateChildren < data.stateArrayA.size():
		var getNode = data.stateArrayA[iterateChildren][0]
		if getNode == nodeAccess:
			branch = data.stateArrayA[iterateChildren][1]
			break
		iterateChildren += 1
	stringName = nodeAccess.get_parent().name + branch
	textStuff._doTextStuff(stringName, "res://overworld/scenes/eart/text/")

func _on_TextStuff_doClose():
	if stringName != "":
		textStuff._defaultClose()
		$"/root/World/Objects/Player".doing = false
