class_name ClimbState
extends State


func _enter(player: Player):
	player.velocity.x = 0
	player.velocity.y *= player.CLIMB_GRAB_Y_MULT
	player.wall_slide_timer = player.WALL_SLIDE_TIME
	player.climb_no_move_timer = player.CLIMB_NO_MOVE_TIME
	
	for i in range(player.CLIMB_CHECK_DIST):
		if not player.collide_check(Vector2.RIGHT * player.facing * (player.HALF_WIDTH + 0.5)):
			player.position += Vector2.RIGHT * player.facing
		else:
			break
		

func _handle_input(player: Player, event: InputEvent):
	pass


func _update(player: Player, delta: float):
	player.climb_no_move_timer -= delta
	
	if player.on_ground:
		player.stamina = player.CLIMB_MAX_STAMINA
	
	# Wall jump
	if InputBuffer.is_action_press_buffered("jump") and\
			(not player.ducking or player.can_un_duck):
		if player.move_x == -player.facing:
			player.wall_jump(-player.facing)
		else:
			player.climb_jump()
		
		player.change_state(player.normal_state)
	
	# Dashing
	if player.can_dash and player.unlocked_dash:
		player.start_dash()
	
	# Leave
	if not Input.is_action_pressed("grab"):
		# NOTE: lift boost?
		player.change_state(player.normal_state)
	
	# climb hop
	if not player.collide_check(Vector2.RIGHT * (player.HALF_WIDTH + 1) * player.facing):
		if (player.velocity.y < 0):
			player.climb_hop()
		player.change_state(player.normal_state)
	
	# Climbing
	var target_: float = 0
	var try_slip: bool = false
	if player.climb_no_move_timer <= 0:
		if Input.is_action_pressed("ui_up"):
			target_ = player.CLIMB_UP_SPEED
			# Up limit
			if player.collide_check(Vector2.UP * (player.HEAD_HEIGHT + 1)):
				if (player.velocity.y < 0):
					player.velocity.y = 0
				target_ = 0
				try_slip = true
		elif Input.is_action_pressed("ui_down"):
			target_ = player.CLIMB_DOWN_SPEED
			if player.on_ground:
				if player.velocity.y > 0:
					player.velocity.y = 0
				target_ = 0
		else:
			try_slip = true
	else:
		try_slip = true
	
	player.last_climb_move = sign(target_)
	if try_slip:
		target_ = player.CLIMB_SLIP_SPEED
	
	player.velocity.y = move_toward(player.velocity.y, target_, player.CLIMB_ACCEL * delta)
	
	# Down limit
	if not Input.is_action_pressed("ui_down") and\
			player.velocity.y > 0 and\
			not player.collide_check(Vector2(player.HALF_WIDTH * player.facing, 1)):
				player.velocity.y = 0
	
	# Stamina
	if player.climb_no_move_timer <= 0:
		if player.last_climb_move == -1:
			player.stamina -= player.CLIMB_UP_COST * delta
		else:
			if player.last_climb_move == 0:
				player.stamina -= player.CLIMB_STILL_COST * delta
	
	if player.stamina <= 0:
		player.change_state(player.normal_state)
	
func _exit(player: Player):
	pass
