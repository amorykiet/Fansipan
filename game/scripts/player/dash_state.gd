class_name DashState
extends State

func _enter(player: Player):
	player.dash_started_on_ground = player.on_ground
	player.dash_cooldown_timer = player.DASH_COOLDOWN
	player.dash_refill_cooldown_timer = player.DASH_REFILL_COOLDOWN
	player.wall_slide_timer = player.WALL_SLIDE_TIME
	
	# NOTE: use to keep if faster speed
	player.before_dash_speed = player.velocity
	player.velocity = Vector2.ZERO
	player.dash_dir = Vector2.ZERO
	
	if not player.on_ground and player.ducking and player.can_un_duck:
		player.ducking = false
		

	# call coroutine
	dash_coroutine(player)


func _handle_input(player: Player, event: InputEvent):
	pass


func _update(player: Player, delta: float):
	
	## Collide horizontal
	#if player.collide_check(Vector2((player.HALF_WIDTH + 1) * sign(player.dash_dir.x), -player.HEAD_HEIGHT)) or\
			#player.collide_check(Vector2((player.HALF_WIDTH + 1) * sign(player.dash_dir.x), player.FOOT_HEIGHT)) or\
			#player.collide_check(Vector2((player.HALF_WIDTH + 1) * sign(player.dash_dir.x), 0)):
		#if player.dash_dir.x != 0 and player.dash_dir.y == 0:
			#player.correct_h_dash()
	#
	## Collide vertical
	#if player.dash_dir.y < 0:
		#if player.dash_dir.x <= 0 and not player.collide_check(Vector2(-player.HALF_WIDTH, - player.HEAD_HEIGHT - 2)):
			#for i in range(player.UPWARD_CORNER_CORRECTION):
				#if player.collide_check(Vector2(player.HALF_WIDTH - i, - player.HEAD_HEIGHT - 3)):
					#player.position.x -= i + 0.5
					#player.position.y -= 1
		#elif player.dash_dir.x >= 0 and not player.collide_check(Vector2(player.HALF_WIDTH, - player.HEAD_HEIGHT - 2)):
			#for i in range(player.UPWARD_CORNER_CORRECTION):
				#if player.collide_check(Vector2(i - player.HALF_WIDTH, - player.HEAD_HEIGHT - 3)):
					#player.position.x += i + 0.5
					#player.position.y -= 1
	#
	pass

func _exit(player: Player):
	pass
	# NOTE: prepare for cool thing
	
	
func dash_coroutine(player: Player):
	await Engine.get_main_loop().physics_frame
	var dir:= player.last_aim
	var new_speed:= dir * player.DASH_SPEED
	
	# Check more speed
	#if sign(player.before_dash_speed.x) == sign(new_speed.x) and\
			#abs(player.before_dash_speed.x) > abs(new_speed.x):
		#new_speed = player.before_dash_speed
	
	player.velocity = new_speed
	player.dash_dir = dir
	
	if player.dash_dir.x != 0:
		player.facing = sign(player.dash_dir.x)
	
	if player.on_ground and player.dash_dir.x != 0 and\
			player.dash_dir.y > 0 and player.velocity.y > 0:
		# NOTE: just confirm
		player.dash_dir.x = sign(player.dash_dir.x)
		player.dash_dir.y = 0
		player.velocity.y = 0
		player.velocity.x *= player.DODGE_SLIDE_SPEED_MULT
		player.ducking = true
	await player.get_tree().create_timer(player.DASH_TIME).timeout
	
	if not player.move_and_collide(player.dash_dir, true):
		if player.dash_dir.y <= 0:
			player.velocity = player.dash_dir * player.END_DASH_SPEED
		
		if player.velocity.y > 0:
			player.velocity.y *= player.END_DASH_UP_MULT

	player.change_state(player.normal_state)
	
