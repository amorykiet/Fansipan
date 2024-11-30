class_name ClimbState
extends State


func _enter(player: Player):
	player.velocity.x = 0
	player.velocity.y *= player.CLIMB_GRAB_Y_MULT
	player.wall_slide_timer = player.WALL_SLIDE_TIME
	player.climb_no_move_timer = player.CLIMB_NO_MOVE_TIME
	
	for i in range(4):
		pass

func _handle_input(player: Player, event: InputEvent):
	pass


func _update(player: Player, delta: float):
	pass


func _exit(player: Player):
	pass
