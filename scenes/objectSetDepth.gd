extends Node2D


var orderArray = []






func _process(delta):
	orderArray.clear()
	var iterateChildren = 0
	while iterateChildren < get_child_count():
		var getNode = get_child(iterateChildren)
		orderArray.append([getNode, getNode.position.y])
		iterateChildren += 1


	orderArray.sort_custom(MyCustomSorter, "sort_ascending")
	
	var setChildren = 0
	while setChildren < get_child_count():
		move_child(orderArray[setChildren][0],setChildren)
		setChildren += 1

class MyCustomSorter:
	static func sort_ascending(a, b):
		if a[1] < b[1]:
			return true
		return false




