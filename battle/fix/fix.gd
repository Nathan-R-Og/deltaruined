extends Node2D

var rng = RandomNumberGenerator.new()

var turn = 0

var teamNumber = 0
var teamAction = []




var team = []
var items = []
var consumables = []
var tp = 0.0


var enemies = []

var menuLayer = 0
var menuIndex = 0
var menuType = ""

var selected = false
var actMGC = ""
var itemPage = 0
var all = false
var fighting = false

func _ready():
	team.append(["machine",
	["Health",102,120],
	["Attack",3,5],
	["Defense",3,3],
	["Magic",0,0],
	[["Sword",0]],
	["ACT", "9A9A9A","machine", Vector2(-155,5)],
	[]
	])


	team.append(["seara",
	["Health",140,140],
	["Attack",2,2],
	["Defense",3,5],
	["Magic",3,3],
	[["Shield",1]],
	["MGC","4FB64C", "seara", Vector2(-155,5)],
	["curve ball", "catapult"]
	])

	team.append(["beta",
	["Health",100,100],
	["Attack",3,4],
	["Defense",3,3],
	["Magic",3,3],
	[["Gun",2]],
	["MGC","FF7000", "beta", Vector2(-155,5)],
	["magic bullet", "gunsling"]
	])








	enemies.append(["dickheadA",
	[["null", 3, ""]],
	[null,[1000,1000],0],
	["Werewire"]
	]
	)

	enemies.append(["dickhead2",
	[["deez", 0, "SHUTFUCK"], ["nuts", 1, "true"]],
	["killable",[5,10],25],
	["Tasque"]
	]
	)

	enemies.append(["dickheadTheThird",
	[["bash", 2, ""]],
	["yeah",[540,777],11],
	["Virovirokun"]
	]
	)



	items.append(["CD Bagel", 0, 20, "Heals 80 HP", 0])
	items.append(["armor", 1, 12, 0])
	items.append(["weapon", 2, 2, 0])
	items.append(["Fuck", 0, 20, "Fuck", 1])
	items.append(["This", 0, 20, "Woopers everywhere agree", 1])
	items.append(["SHIT", 0, 20, "Kaizo Super Mario World", 0])
	items.append(["I hate this", 0, 20, "I know, right?", 0])
	items.append(["Wowie", 0, 20, "Yeah", 0])
	items.append(["DIE", 0, 20, "Heals -80 HP", 0])


	playerMENU()
	
	var iterateSpawnTeam = 0
	while iterateSpawnTeam < team.size():
		var character = load("res://battle/battleAsset/chra/Player" + String(iterateSpawnTeam + 1) + "Battle.tscn").instance()
		$Players/The.add_child(character)
		character.position = $Players/pos.get_node(String(iterateSpawnTeam + 1)).position
		iterateSpawnTeam += 1
	var iterateSpawnEnemy = 0
	while iterateSpawnEnemy < enemies.size():
		var enemy = load("res://battle/battleAsset/enemy/" + enemies[iterateSpawnEnemy][0] + ".tscn").instance()
		$Players/The.add_child(enemy)
		enemy.position = $Enemies/pos.get_node(String(iterateSpawnEnemy + 1)).position
		iterateSpawnEnemy += 1
		
	
	fighting = true
	
	turn = 1
	menuIndex = 1
	_changeCurrent()
	consume()




func playerMENU():
	var i = 0
	while i < team.size():
		var playerMENU = preload("res://battle/battleAsset/PLAYERmenu.tscn").instance()
		if team.size() == 3:
			playerMENU.position.x = (426 * i) + 213
		playerMENU.position.y = 627
		playerMENU.name = "P" + String(i + 1)
		$Control.add_child(playerMENU)
		i += 1






func _changeCurrent():
	var iterateTeamDisable = 1
	while iterateTeamDisable < team.size() + 1:
		var PlayerNodeSelect = $Control.get_node("P" + String(iterateTeamDisable))
		var playerInfoCheck = PlayerNodeSelect.get_node("PlayerInfoLayer").position.y
		var playerInfoAnimate = PlayerNodeSelect.get_node("AnimationPlayer")
		
		var setName = $Control.get_node("P" + String(iterateTeamDisable)).get_node("PlayerInfoLayer").get_node("name")
		var nameSet = team[iterateTeamDisable - 1][6][2]
		var dir = Directory.new()
		var fileDir = "res://Sprites/battle/playerNAME/" + nameSet + ".png"
		if dir.file_exists(fileDir):
			setName.get_node("Sprite").texture = load(fileDir)
		else:
			setName.text = nameSet

		if iterateTeamDisable != teamAction.size() + 1 and all != true:
			if playerInfoCheck != 64:
				$Control.get_node("P" + String(iterateTeamDisable)).get_node("PlayerInfoLayer").get_node("color").hide()
				$Control.get_node("P" + String(iterateTeamDisable)).get_node("Menu").get_node("color").hide()
				$Control.get_node("P" + String(iterateTeamDisable)).get_node("Menu").get_node("Flash").hide()
				playerInfoAnimate.play("Lower")
			else:
				pass
		else:
			$Control.get_node("P" + String(iterateTeamDisable)).get_node("PlayerInfoLayer").get_node("color").show()
			$Control.get_node("P" + String(iterateTeamDisable)).get_node("Menu").get_node("color").show()
			$Control.get_node("P" + String(iterateTeamDisable)).get_node("Menu").get_node("Flash").show()
			playerInfoAnimate.play("Reveal")
		iterateTeamDisable += 1
	if teamAction.size() < team.size() - 1:
		
		var get = teamAction.size() + 2
		var getNode = $Control.get_node("P" + String(get))
		var gtfo = 0
		while gtfo < getNode.get_node("Menu").get_child_count():
			var node = getNode.get_node("Menu").get_child(gtfo)
			if node.get_class() == "AnimatedSprite":
				node.animation = "normal"
			gtfo += 1





func consume():
	consumables.clear()
	
	var i = 0
	while i < items.size():
		if items[i][1] == 0:
			consumables.append(items[i])
		i += 1




func _process(delta):
	
	var check = 0
	while check < team.size():
		var xSize = 76.0
		var GET = $Control.get_node("P" + String(check + 1)).get_node("PlayerInfoLayer").get_node("Health")
		var outOf = float(team[check][1][1]) / float(team[check][1][2])
		var to = xSize * outOf
		var bar = GET.get_node("bar").get_node("bar_current")
		bar.scale.x = to
		bar.position.x = to - xSize
		var COLOR = Color(team[check][6][1])
		bar.set_modulate(COLOR)
		var icon = $Control.get_node("P" + String(check + 1)).get_node("PlayerInfoLayer").get_node("icon")
		var framesPath = "res://Sprites/battle/party/" + team[check][0] + "/" + team[check][0] + ".tres"
		icon.frames = load(framesPath)
		if check <= teamAction.size() - 1:
			var ACTION = teamAction[check]
			match ACTION[0]:
				"ATK":
					icon.animation = "attack"
				"MGC":
					icon.animation = "tech"
				"ACT":
					icon.animation = "tech"
				"ITM":
					icon.animation = "item"
				"SPR":
					icon.animation = "spare"
				"DEF":
					icon.animation = "defend"
		else:
			icon.animation = "normal"
		$Control.get_node("P" + String(check + 1)).get_node("PlayerInfoLayer").get_node("icon").position = team[check][6][3]
		$Control.get_node("P" + String(check + 1)).get_node("Menu").get_node("color").set_modulate(COLOR)
		$Control.get_node("P" + String(check + 1)).get_node("Menu").get_node("Flash").set_modulate(COLOR)
		$Control.get_node("P" + String(check + 1)).get_node("PlayerInfoLayer").get_node("color").set_modulate(COLOR)
		GET.get_node("current").text = String(team[check][1][1])
		GET.get_node("max").text = String(team[check][1][2])
		check += 1














	if all == true:
		fighting = false

	if fighting == true:
		match selected:
			true:
				$pla.show()
				match menuType:
					"ATK":
						var count = $Control/MBox/EnemyStats.get_child_count()
						if count <= 3:
							if Input.is_action_just_pressed("move_down"):
								menuIndex += 1
							if Input.is_action_just_pressed("move_up"):
								menuIndex -= 1
							if menuIndex <= 0:
								menuIndex = count
							if menuIndex >= count + 1:
								menuIndex = 1
						$pla.global_position.y = $Control/MBox/EnemyStats.get_child(menuIndex - 1).global_position.y + 1
						$pla.global_position.x = 126
						if Input.is_action_just_pressed("accept"):
							runTurnEnd(["ATK",menuIndex])
					"MGC":
						match menuLayer:
							0:
								match actMGC:
									"ACT":
										var count = $Control/MBox/EnemyStats.get_child_count()
										if count <= 3:
											if Input.is_action_just_pressed("move_down"):
												menuIndex += 1
											if Input.is_action_just_pressed("move_up"):
												menuIndex -= 1
											if menuIndex <= 0:
												menuIndex = count
											if menuIndex >= count + 1:
												menuIndex = 1
										$pla.global_position.y = $Control/MBox/EnemyStats.get_child(menuIndex - 1).global_position.y + 1
										$pla.global_position.x = 126
										if Input.is_action_just_pressed("accept"):
											itemPage = menuIndex - 1
											menuIndex = 1
											rendu("destroy")
											menuLayer = 1
											rendu("create")
							1:
								match actMGC:
									"ACT":
										var count = $Control/MBox/EnemyStats.get_child_count()
										if Input.is_action_just_pressed("move_down") and (menuIndex - 1) < count - 2:
											menuIndex += 2
										if Input.is_action_just_pressed("move_up") and (menuIndex - 1) > 1:
											menuIndex -= 2
										if Input.is_action_just_pressed("move_right") and count > 1:
											if (menuIndex - 1) % 2 != 1:
												menuIndex += 1
											else:
												menuIndex -= 1
										if Input.is_action_just_pressed("move_left") and count > 1:
											if (menuIndex - 1) % 2 != 1:
												menuIndex += 1
											else:
												menuIndex -= 1
										$pla.global_position.y = 786 + (int(floor((menuIndex - 1) / 2)) * 60)
										$pla.global_position.x = 36 + (((menuIndex - 1) % 2) * 440)
										$Control/MBox/Label.text = enemies[itemPage][1][menuIndex - 1][2]
										if Input.is_action_just_pressed("accept"):
											runTurnEnd(["ACT", itemPage + 1, [itemPage, 1 , menuIndex - 1]])
					"ITM":
						var count = $Control/MBox/EnemyStats.get_child_count()
						if Input.is_action_just_pressed("move_down") and (menuIndex - 1) < count - 2:
							menuIndex += 2
						if Input.is_action_just_pressed("move_up") and (menuIndex - 1) > 1:
							menuIndex -= 2
						if Input.is_action_just_pressed("move_right"):
							if (menuIndex - 1) % 2 != 1:
								menuIndex += 1
							else:
								menuIndex -= 1
						if Input.is_action_just_pressed("move_left"):
							if (menuIndex - 1) % 2 != 1:
								menuIndex += 1
							else:
								menuIndex -= 1
						$pla.global_position.y = 786 + (int(floor((menuIndex - 1) / 2)) * 60)
						$pla.global_position.x = 36 + (((menuIndex - 1) % 2) * 440)
						var dataSwag = consumables[menuIndex - 1]
						$Control/MBox/Label.text = dataSwag[3]
					"SPR":
						match menuLayer:
							0:
								var count = $Control/MBox/EnemyStats.get_child_count()
								if count <= 3:
									if Input.is_action_just_pressed("move_down"):
										menuIndex += 1
									if Input.is_action_just_pressed("move_up"):
										menuIndex -= 1
									if menuIndex <= 0:
										menuIndex = count
									if menuIndex >= count + 1:
										menuIndex = 1
								$pla.global_position.y = $Control/MBox/EnemyStats.get_child(menuIndex - 1).global_position.y + 1
								$pla.global_position.x = 126
					"DEF":
						runTurnEnd(["DEF"])
				if menuLayer == 0 and Input.is_action_just_pressed("decline"):
					rendu("destroy")
					match menuType:
						"ATK":
							menuIndex = 1
						"MGC":
							menuIndex = 2
						"ITM":
							menuIndex = 3
						"SPR":
							menuIndex = 4
						"DEF":
							menuIndex = 5
					actMGC = ""
					menuType = ""
					selected = false
					$Control/MBox/Label.text = ""
					$pla.hide()
				elif menuLayer == 1 and Input.is_action_just_pressed("decline"):
					$Control/MBox/Label.text = ""
					rendu("destroy")
					menuIndex = itemPage + 1
					menuLayer -= 1
					rendu("create")
			false:
				itemPage = 0
				if Input.is_action_just_pressed("move_right"):
					menuIndex += 1
				if Input.is_action_just_pressed("move_left"):
					menuIndex -= 1
				if menuIndex <= 0:
					menuIndex = 5
				elif menuIndex >= 6:
					menuIndex = 1
				
				
				var get = teamAction.size() + 1
				var getNode = $Control.get_node("P" + String(get))
				
				var gtfo = 0
				while gtfo < getNode.get_node("Menu").get_child_count():
					var node = getNode.get_node("Menu").get_child(gtfo)
					if node.get_class() == "AnimatedSprite":
						node.animation = "normal"
					gtfo += 1
				getNode.get_node("Menu").get_child(menuIndex - 1 + 3).animation = "on"

				if Input.is_action_just_pressed("accept"):
					match menuIndex:
						1:
							menuType = "ATK"
						2:
							menuType = "MGC"
						3:
							menuType = "ITM"
						4:
							menuType = "SPR"
						5:
							menuType = "DEF"
					if (menuType == "ITM" and items.size() == 0):
						pass
					else:
						menuIndex = 1
						rendu("create")
						selected = true
				elif Input.is_action_just_pressed("decline") and teamAction.size() > 0:
					var action = teamAction[teamAction.size() - 1][0]
					match action:
						"ATK":
							menuIndex = 1
						"MGC":
							menuIndex = 2
						"ACT":
							menuIndex = 2
						"ITM":
							menuIndex = 3
						"SPR":
							menuIndex = 4
						"DEF":
							menuIndex = 5
					teamAction.remove(teamAction.size() - 1)
					itemPage = 0
					_changeCurrent()




func runTurnEnd(syntax):
	var get = teamAction.size() + 1
	var getNode = $Control.get_node("P" + String(get))
	var gtfo = 0
	while gtfo < getNode.get_node("Menu").get_child_count():
		var node = getNode.get_node("Menu").get_child(gtfo)
		if node.get_class() == "AnimatedSprite":
			node.animation = "normal"
		gtfo += 1
	rendu("destroy")
	teamAction.append(syntax)
	_changeCurrent()
	match menuType:
		"ATK":
			menuIndex = 1
		"MGC":
			menuIndex = 2
		"ITM":
			menuIndex = 3
		"SPR":
			menuIndex = 4
		"DEF":
			menuIndex = 5
	actMGC = ""
	menuType = ""
	menuLayer = 0
	itemPage = 0
	selected = false
	$pla.hide()
	if teamAction.size() == team.size():
		all = true




func rendu(mode):
	match menuType:
		"ATK":
			if mode == "create":
				enemyRender()
			elif mode == "destroy":
				var createPerEnemy = $Control/MBox/EnemyStats.get_child_count()
				while createPerEnemy > 0:
					$Control/MBox/EnemyStats.get_child(createPerEnemy - 1).queue_free()
					createPerEnemy -= 1
		"MGC":
			var partyTurn = teamAction.size()
			var getWhich = team[partyTurn][6][0]
			actMGC = getWhich
			match actMGC:
				"ACT":
					if menuLayer == 0:
						if mode == "create":
							enemyRender()
						elif mode == "destroy":
							var createPerEnemy = $Control/MBox/EnemyStats.get_child_count()
							while createPerEnemy > 0:
								$Control/MBox/EnemyStats.get_child(createPerEnemy - 1).queue_free()
								createPerEnemy -= 1
					if menuLayer == 1:
						if mode == "create":
							var i = 0
							while i < enemies[itemPage][1].size():
								var itemList = preload("res://battle/battleAsset/NameInstance.tscn").instance()
								$Control/MBox/EnemyStats.add_child(itemList)
								var column = int(floor(i / 2.0))
								var base = i % 2
								itemList.position.x = -449 + (base * 460)
								var side = column % 3
								itemList.position.y = -57 + (60 * side)
								itemList.get_node("Name").text = enemies[itemPage][1][i][0]
								i += 1
						elif mode == "destroy":
							var createPerEnemy = $Control/MBox/EnemyStats.get_child_count()
							while createPerEnemy > 0:
								$Control/MBox/EnemyStats.get_child(createPerEnemy - 1).queue_free()
								createPerEnemy -= 1
		"ITM":
			if mode == "create":
				var i = itemPage * 6
				while i < consumables.size() and i < (itemPage + 1) * 6:
					var itemList = preload("res://battle/battleAsset/NameInstance.tscn").instance()
					$Control/MBox/EnemyStats.add_child(itemList)
					var column = int(floor(i / 2.0))
					var base = i % 2
					itemList.position.x = -449 + (base * 460)
					var side = column % 3
					itemList.position.y = -57 + (60 * side)
					itemList.get_node("Name").text = consumables[i][0]
					i += 1
			elif mode == "destroy":
				var i = $Control/MBox/EnemyStats.get_child_count()
				while i > 0:
					$Control/MBox/EnemyStats.get_child(i - 1).queue_free()
					i -= 1
		"SPR":
			if mode == "create":
				enemyRender()
			elif mode == "destroy":
				var i = $Control/MBox/EnemyStats.get_child_count()
				while i > 0:
					$Control/MBox/EnemyStats.get_child(i - 1).queue_free()
					i -= 1

func enemyRender():
	var createPerEnemy = 0
	while createPerEnemy < enemies.size():
		var enemyStuffBox = preload("res://battle/battleAsset/EnemyName.tscn").instance()
		$Control/MBox/EnemyStats.add_child(enemyStuffBox)
		enemyStuffBox.position.y = -57 + (60 * createPerEnemy)
		enemyStuffBox.position.x = 0
		enemyStuffBox.get_node("EnemyName").text = enemies[createPerEnemy][3][0]
		if enemies[createPerEnemy][2][0] != null:
			enemyStuffBox.get_node("EnemyState").text = enemies[createPerEnemy][2][0]
		var outOf = float(enemies[createPerEnemy][2][1][0]) / float(enemies[createPerEnemy][2][1][1])
		var percentRender = String(ceil(outOf * 100.0)) + "%"
		enemyStuffBox.get_node("HP_bar/bar_percent").text = percentRender
		enemyStuffBox.get_node("SPARE_bar/bar_percent").text = String(enemies[createPerEnemy][2][2]) + "%"
		createPerEnemy += 1
