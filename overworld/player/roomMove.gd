extends KinematicBody2D

var direction = "down"
export var world = "dark"
var worldChange = true
export var animPath = "res://Sprites/kris/"





export var playerId = 1
var playerInput = Vector2()
var playerXInput = 0.0
var playerYInput = 0.0
var playerVelocity = Vector2()
var walkSpd = 120
var speedScalar = walkSpd
var running = false
var runInc = 1.0
var runBase = 20
var runTimer = 0.0
var runSet = 1
var do = null


var doing = false
var doable = false


var recording = true
var recordX = []
var recordY = []
var recordSize = 256

var moving = false
var angler = 0.0







func _ready():
	# partyMember playerInput to source from
	recordX.resize(recordSize)
	recordY.resize(recordSize)
	var iterater = 0
	while iterater < recordSize - 1:
		recordX[iterater] = position.x
		recordY[iterater] = position.y
		iterater += 1
	
	worldCheck()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	running = Input.is_action_pressed("decline1")

	
	
	
	
	if doing == false:
		
		
		
		if running == true:
			if runInc == 1.0:
				runSet = 1
			if runInc >= 1.0:
				runTimer += delta
			
			
			
			if runTimer >= 0.6 and runSet == 1:
				runInc = 5
				runSet = 2
			speedScalar = walkSpd + (runInc * runBase)
		else:
			runInc = 1.0
			runSet = 1
			runTimer = 0.0
			speedScalar = walkSpd
		playerXInput = Input.get_action_strength("move_right" + String(playerId)) - Input.get_action_strength("move_left" + String(playerId))
		playerYInput = Input.get_action_strength("move_down" + String(playerId)) - Input.get_action_strength("move_up" + String(playerId))
		playerInput = Vector2(playerXInput, playerYInput)
		playerVelocity = playerInput * speedScalar
		
		playerVelocity = move_and_slide(playerVelocity)


		angler = abs(-(rad2deg(atan2(playerInput.y,-playerInput.x)) + 180))
		
		
		
		if playerInput != Vector2(0.0,0.0):
			directionality()
			var iterateAnim = 0
			while iterateAnim < $PlayerSprite.frames.get_animation_names().size():
				var TempSpeed = 0.0
				match runSet:
					1:
						TempSpeed = 5.0
					2:
						TempSpeed = 7.5
				$PlayerSprite.frames.set_animation_speed($PlayerSprite.frames.get_animation_names()[iterateAnim], TempSpeed)
				iterateAnim += 1
		
		#if playerInput.x > 0 and playerInput.y > 0:
			#if playerInput.x == playerInput.y:
			#	direction = "downRight"
		#	if playerInput.x > playerInput.y:
		#		direction = "right"
		#	if playerInput.x < playerInput.y:
		#		direction = "down"
		#elif playerInput.x < 0 and playerInput.y > 0:
			#if -playerInput.x == playerInput.y:
			#	direction = "downLeft"
		#	if -playerInput.x > playerInput.y:
		#		direction = "left"
		#	if -playerInput.x < playerInput.y:
		#		direction = "down"
		#elif playerInput.x < 0 and playerInput.y < 0:
			#if -playerInput.x == -playerInput.y:
			#	direction = "upLeft"
		#	if -playerInput.x > -playerInput.y:
		#		direction = "left"
		#	if -playerInput.x < -playerInput.y:
		#		direction = "up"
		#elif playerInput.x > 0 and playerInput.y < 0:
			#if playerInput.x == -playerInput.y:
			#	direction = "upRight"
		#	if playerInput.x > -playerInput.y:
		#		direction = "right"
		#	if playerInput.x < -playerInput.y:
		#		direction = "up"
		#if playerInput.x > 0 and playerInput.y == 0:
		#	direction = "right"
		#if playerInput.x < 0 and playerInput.y == 0:
		#	direction = "left"
		#if playerInput.x == 0 and playerInput.y > 0:
		#	direction = "down"
		#if playerInput.x == 0 and playerInput.y < 0:
		#	direction = "up"



		match direction:
			"down":
				$interact.position = Vector2(0,32)
			"downRight":
				$interact.position = Vector2(16,32)
			"downLeft":
				$interact.position = Vector2(-16,32)
			"right":
				$interact.position = Vector2(16,16)
			"left":
				$interact.position = Vector2(-16,16)
			"up":
				$interact.position = Vector2(0,0)
			"upRight":
				$interact.position = Vector2(16,0)
			"upLeft":
				$interact.position = Vector2(-16,0)

		if do != null and Input.is_action_just_pressed("accept" + String(playerId)) and doing == false:
			doing = true
			if do.name.find("Player") == -1:
				do.readyTextStuff()
			else:
				do.get_node("textRun").readyTextStuff()



		

		if playerVelocity != Vector2(0,0):
			
			
			
			

			
			
			moving = true
			$PlayerSprite.play(direction)
		else:
			print("a")
			moving = false
			$PlayerSprite.stop()
			var restSpd = 0.3
			if $PlayerSprite.frame == 1:
				yield(get_tree().create_timer(restSpd),"timeout")
				$PlayerSprite.frame = 2
			elif $PlayerSprite.frame == 3:
				yield(get_tree().create_timer(restSpd),"timeout")
				$PlayerSprite.frame = 0


		if recording == true:
			if position.x != recordX[0] or position.y != recordY[0]:
				var shift = recordSize - 2
				while shift > 0:
					recordX[shift] = recordX[shift - 1]
					recordY[shift] = recordY[shift - 1]
					shift -= 1
				recordX[0] = position.x
				recordY[0] = position.y





func directionality():
	match angler:
		360.0:
			direction = "right"
		#45.0:
		#	direction = "upRight"
		90.0:
			direction = "up"
		#135.0:
		#	direction = "upLeft"
		180.0:
			direction = "left"
		#225.0:
		#	direction = "downLeft"
		270.0:
			direction = "down"
		#315.0:
		#	direction = "downRight"
	if data.lastDir != []:
		$PlayerSprite.animation = data.lastDir[0]
	else:
		$PlayerSprite.animation = direction



func worldCheck():
	if worldChange == true:
		var worldAdd = ""
		match world:
			"dark":
				worldAdd = "dw"
			"light":
				worldAdd = "lw"
		var path = animPath + worldAdd + "/" + "anims" + worldAdd + ".tres"
		var frames = load(path)
		$PlayerSprite.frames = frames
		worldChange = false

func _on_interact_body_entered(body):
	if body.name != "Player":
		do = body
		doable = true


func _on_interact_body_exited(body):
	if body.name != "Player":
		do = null
		doable = false
