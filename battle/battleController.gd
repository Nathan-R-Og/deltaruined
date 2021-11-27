extends Node2D


var team = ["sir lad","miss uior","the great"]




var rng = RandomNumberGenerator.new()
var battleAttack = 0
var turn = 0
var turnIndex = 0
var teamAmount = 3
var teamActive = true
var enemyActive = false
var teamActioning = false


var teamAction = []
var menuIndex = 1
var menuLayer = 0
var menuType = ""
var subIndex = [[[1,0],1],[[1,0],1],[[1,0],1]]
var subIndexAlter = 0
var sidewaysNav = false


var enemies = ["dickheadA","dickhead2","dickheadTheThird"]
var enemyAct = [null,["deez", "nuts"], "bash"]
var enemyStat = [[null,[1000,1000],0], ["killable",[5,10],25], ["yeah",[540,777],11]]



func _ready():
	var iterateSpawnTeam = 0
	while iterateSpawnTeam < team.size():
		#change this to reference by name later
		var character = load("res://battle/battleAsset/chra/Player" + String(iterateSpawnTeam + 1) + "Battle.tscn").instance()
		$Players/The.add_child(character)
		character.position = $Players/pos.get_node(String(iterateSpawnTeam + 1)).position
		$Control.get_node("P" + String(iterateSpawnTeam + 1)).get_node("PlayerInfoLayer").get_node("name").text = team[iterateSpawnTeam]
		iterateSpawnTeam += 1
	var iterateSpawnEnemy = 0
	while iterateSpawnEnemy < enemies.size():
		var enemy = load("res://battle/battleAsset/enemy/" + enemies[iterateSpawnEnemy] + ".tscn").instance()
		$Players/The.add_child(enemy)
		enemy.position = $Enemies/pos.get_node(String(iterateSpawnEnemy + 1)).position
		iterateSpawnEnemy += 1
		
	
	
	
	turn = 1
	_changeCurrent()

func _process(delta):
	
	
	if Input.is_action_just_pressed("decline") and teamActive == false:
		battleAttack = 1
		_battleDraw()

# inside options
	if Input.is_action_just_pressed("accept") and teamActive == true:
		_layerMovement("down")
	if Input.is_action_just_pressed("decline") and teamActive == true:
		_layerMovement("up")


# option navigation
	if Input.is_action_just_pressed("move_left") and teamActive == true:
		if menuLayer == 0:
			menuIndex -= 1
			if menuIndex == 0:
				menuIndex = 5
	if Input.is_action_just_pressed("move_right") and teamActive == true:
		if menuLayer == 0:
			menuIndex += 1
			if menuIndex == 6:
				menuIndex = 1



	
# layer navigation
	match menuType:
		"ATK":
			$Control/MBox/NAV.show()
			sidewaysNav = false
			subIndexAlter = 0
			subIndex[turn - 1][0][1] = enemies.size()
			
			$Control/MBox/NAV.position.x = -514
			$Control/MBox/NAV.position.y = -56 + ((subIndex[turn - 1][0][0] - 1) * 64)
		"":
			$Control/MBox/NAV.hide()

	if menuLayer != 0 and teamActive == true:
		if sidewaysNav == true:
			if Input.is_action_just_pressed("move_left"):
				subIndex[turn - 1][subIndexAlter][0] = clamp(subIndex[turn - 1][subIndexAlter][0] - 1, 1, subIndex[turn - 1][subIndexAlter][1])
			if Input.is_action_just_pressed("move_right"):
				subIndex[turn - 1][subIndexAlter][0] = clamp(subIndex[turn - 1][subIndexAlter][0] + 1, 1, subIndex[turn - 1][subIndexAlter][1])
			if Input.is_action_just_pressed("move_up"):
				subIndex[turn - 1][subIndexAlter][0] = clamp(subIndex[turn - 1][subIndexAlter][0] - 2, 1, subIndex[turn - 1][subIndexAlter][1])
			if Input.is_action_just_pressed("move_down"):
				subIndex[turn - 1][subIndexAlter][0] = clamp(subIndex[turn - 1][subIndexAlter][0] + 2, 1, subIndex[turn - 1][subIndexAlter][1])
		else:
			if Input.is_action_just_pressed("move_up"):
				subIndex[turn - 1][subIndexAlter][0] = clamp(subIndex[turn - 1][subIndexAlter][0] - 1, 1, subIndex[turn - 1][subIndexAlter][1])
			if Input.is_action_just_pressed("move_down"):
				subIndex[turn - 1][subIndexAlter][0] = clamp(subIndex[turn - 1][subIndexAlter][0] + 1, 1, subIndex[turn - 1][subIndexAlter][1])
	elif menuLayer == 0 and teamActive == true:
		var clear = 0
		while clear < $Control.get_node("P" + String(turn)).get_node("Menu").get_child_count():
			if clear != menuIndex - 1:
				var unhighlight = $Control.get_node("P" + String(turn)).get_node("Menu").get_child(clear)
				unhighlight.modulate.r = 25/255
			else:
				var highlight = $Control.get_node("P" + String(turn)).get_node("Menu").get_child(menuIndex - 1)
				highlight.modulate.r = 255/255
			clear += 1
	

func _layerMovement(type):
	
	var ATKdone = type == "down" and menuLayer == 1 and menuType == "ATK"
	var MAGICdone = false
	var ITEMdone = false
	var SPAREdone = false
	var DEFENDdone = false
	
	
	
	if type == "down" and menuLayer == 0:
		match menuIndex:
			1:
				menuType = "ATK"
				menuLayer = 1
				var createPerEnemy = 0
				while createPerEnemy < enemies.size():
					var enemyStuffBox = preload("res://battle/battleAsset/EnemyName.tscn").instance()
					$Control/MBox/EnemyStats.add_child(enemyStuffBox)
					enemyStuffBox.position.y = -52 + (64 * createPerEnemy)
					enemyStuffBox.position.x = 0
					enemyStuffBox.get_node("EnemyName").text = enemies[createPerEnemy]
					if enemyStat[createPerEnemy][0] != null:
						enemyStuffBox.get_node("EnemyState").text = enemyStat[createPerEnemy][0]
					var outOf = float(enemyStat[createPerEnemy][1][0]) / float(enemyStat[createPerEnemy][1][1])
					var percentRender = String(ceil(outOf * 100.0)) + "%"
					enemyStuffBox.get_node("HP_bar/bar_percent").text = percentRender
					enemyStuffBox.get_node("SPARE_bar/bar_percent").text = String(enemyStat[createPerEnemy][2]) + "%"
					createPerEnemy += 1
	
	if type == "up" and menuLayer != 0:
		match menuType:
			"ATK":
				_elementDelete("enemyStuff")
	
	
	
	

	
	if type == "down":
		if ATKdone or MAGICdone or ITEMdone or SPAREdone or DEFENDdone:
			teamAction.append(menuType)
			_elementDelete("enemyStuff")
			if turn >= teamAmount:
				teamActioning = true
				teamActive = false
				turn = 0
				_changeCurrent()
			else:
				turn += 1
				_changeCurrent()
			
	elif type == "up":
		if menuLayer == 0:
			turn = clamp(turn - 1, 0, 999)
			if turn != 0:
				_changeCurrent()
			else:
				turn = 1



func _elementDelete(element):
	match element:
		"enemyStuff":
			var killChildren = $Control/MBox/EnemyStats.get_child_count() - 1
			while killChildren > -1:
				$Control/MBox/EnemyStats.get_child(killChildren).queue_free()
				killChildren -= 1






func _battleDraw():
	match battleAttack:
		1:
			$StaticBody2D/AnimationPlayer.play("1")


func _changeCurrent():
	menuLayer = 0
	menuType = ""
	var iterateTeamDisable = teamAmount
	while iterateTeamDisable > 0:
		var PlayerNodeSelect = $Control.get_node("P" + String(iterateTeamDisable))
		var playerInfoCheck = PlayerNodeSelect.get_node("PlayerInfoLayer").position.y
		var playerInfoAnimate = PlayerNodeSelect.get_node("AnimationPlayer")
		if iterateTeamDisable != turn:
			if playerInfoCheck != 64:
				playerInfoAnimate.play("Lower")
			else:
				pass
		else:
			playerInfoAnimate.play("Reveal")
		iterateTeamDisable -= 1
