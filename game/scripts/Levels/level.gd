extends Node

@export var start_room: Room
@export var start_checkpoint: CheckPoint
@export var gameplay_camera: GameplayCamera
@export var player: Player

var cur_checkpoint: Vector2

func _ready():
	# setup player
	player.player_deaded.connect(revive_player)
	player.global_position = start_checkpoint.global_position
	
	# setup checkpoints
	var check_point_list: Array = get_tree().get_nodes_in_group("CheckPoint")
	for check_point: CheckPoint in check_point_list:
		check_point.player_entered.connect(set_new_checkpoint)
	
	# setup rooms
	var room_list: Array = get_tree().get_nodes_in_group("Room")
	for room: Room in room_list:
		room.player_entered.connect(set_new_room)
	
	# setup camera
	gameplay_camera.global_position = Constants.WINDOW_SIZE/2 + Vector2i.ONE
	gameplay_camera.set_room(start_room).set_target(player, 8)
	gameplay_camera.enabled = true


func set_new_checkpoint(pos: Vector2):
	cur_checkpoint = pos

func revive_player():
	player.global_position = cur_checkpoint
	player.deaded = false

func set_new_room(new_room: Room):
	gameplay_camera.set_room(new_room)
