class_name NormalState
extends State


func _enter(player: Player):
	player.max_fall = player.MAX_FALL


func _handle_input(player: Player, event: InputEvent):
	pass



func _update(player: Player, delta: float):
	# TESTING: normal movement
	
	# Climb
	if (Input.is_action_pressed("grab") and not player.is_tired and not player.ducking):
		if player.velocity.y >= 0 and sign(player.velocity.x) != -player.facing:
			if player.climb_check(player.facing):
				player.ducking = false
				player.change_state(player.climb_state)
			
	# TODO: dashing
	# Ducking
	if player.ducking:
		if player.on_ground and player.move_y != 1:
			# TODO: check can unduck and scale sprite
			player.ducking = false
	elif (player.on_ground and player.move_y == 1 and player.velocity.y >= 0):
		player.ducking = true
		# TODO: scale sprite
	
	
	# Run and Friction
	# TODO correct unduck
	if player.ducking and player.on_ground:
		player.velocity.x = move_toward(player.velocity.x, 0, player.DUCK_FRICTION * delta)
	else:
		var mult: float = 1.0
		if not player.on_ground:
			mult = player.AIR_MULT
		
		var max_run: float = player.MAX_RUN
		if abs(player.velocity.x) > max_run and sign(player.velocity.x) == player.move_x:
			player.velocity.x = move_toward(player.velocity.x, 
					player.move_x * max_run, player.RUN_REDUCE * mult * delta)
		else:
			player.velocity.x = move_toward(player.velocity.x,
					player.move_x * max_run, player.RUN_ACCEL * mult * delta)
		
	#region verical
	# Calculate current max fall speed
	var mf = player.MAX_FALL
	var fmf = player.FAST_MAX_FALL
	
	#fast fall
	if Input.is_action_pressed("ui_down") and player.velocity.y >= mf:
		player.max_fall = move_toward(player.max_fall, fmf, player.FAST_MAX_ACCEL * delta)
	else:
		player.max_fall = move_toward(player.max_fall, mf, player.FAST_MAX_ACCEL * delta)

	# Gravity
	if not player.on_ground:
		var max_: float = player.max_fall
		
		# Wall Slice
		if player.move_y != 1 and (\
				player.move_x == player.facing or\
				(Input.is_action_pressed("grab") and player.move_x == 0)):
			if player.velocity.y >= 0 and\
					player.wall_slide_timer > 0 and\
					player.collide_check(Vector2.RIGHT *\
							(player.WALL_SLIDE_CHECK_DIST + player.HALF_WIDTH) * player.facing):
				player.wall_slide_dir = player.facing
			
			if player.wall_slide_dir != 0:
				max_ = lerpf(player.MAX_FALL, player.WALL_SLIDE_START_MAX,\
						player.wall_slide_timer / player.WALL_SLIDE_TIME)
		
		var mutl: float = \
			0.5 if (abs(player.velocity.y) < player.HALF_GRAV_THRESHOLD)\
			and Input.is_action_pressed("jump")\
			else 1.0
		player.velocity.y = move_toward(player.velocity.y, max_, mutl * player.GRAVITY * delta)
		
	# Variable Jump
	if player.var_jump_timer > 0:
		if Input.is_action_pressed("jump"):
			player.velocity.y = minf(player.velocity.y, player.var_jump_speed)
		else:
			player.var_jump_timer = 0
	
	# Jumping
	if InputBuffer.is_action_press_buffered("jump"):
		if player.jump_grace_timer > 0:
			player.jump()
		elif(player.can_un_duck):
			# NOTE: ClimbJump, SupperWallJump?
			if player.wall_jump_check(1):
				if player.facing == 1 and\
						Input.is_action_pressed("grab") and\
						player.stamina > 0:
					player.climb_jump()
				else:
					player.wall_jump(-1)
			elif player.wall_jump_check(-1):
				if player.facing == -1 and\
						Input.is_action_pressed("grab") and\
						player.stamina > 0:
					player.climb_jump()
				else:
					player.wall_jump(1)

	#endregion
func _exit(player: Player):
	player.hop_wait_x = 0
