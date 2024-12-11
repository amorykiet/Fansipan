class_name Level
extends Node

signal level_completed(pos: Vector2)

@export var start_room: Room
@export var start_checkpoint: CheckPoint
@export var gameplay_camera: GameplayCamera
@export var player: Player

var cur_room: Room
var cur_checkpoint: Vector2
var completed: bool = false
var started: bool = false

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



func _process(delta):
	if get_tree().paused and not completed:
		if not gameplay_camera.changing_room:
			# player enter new room
			get_tree().paused = false

func set_new_checkpoint(pos: Vector2):
	cur_checkpoint = pos

func revive_player():
	player.global_position = cur_checkpoint
	player.facing = sign(player.global_position.direction_to(cur_room.center).x)
	player.velocity = Vector2.ZERO
	player.current_state = player.normal_state
	gameplay_camera.changing_room = false
	player.deaded = false

func set_new_room(new_room: Room):
	cur_room = new_room
	gameplay_camera.set_room(new_room)
	player.room = new_room
	player.refill_full()
	get_tree().paused = true
	fit_player_to_room(new_room)

func fit_player_to_room(room: Room):
	var boundary_:= room.boundary
	var up_limit:= boundary_.position.y + room.position.y + 11
	var down_limit:= boundary_.position.y + boundary_.size.y + room.position.y - 30
	var left_limit:= boundary_.position.x + room.position.x + player.HALF_WIDTH * 2
	var right_limit:= boundary_.position.x + boundary_.size.x + room.position.x - player.HALF_WIDTH * 2
	
	player.global_position.x = clamp(player.global_position.x, left_limit, right_limit)
	player.global_position.y = clamp(player.global_position.y, up_limit, down_limit)
	

func start():
	started = true
	gameplay_camera.started = true
	player.started = true

func complete_level(body):
	completed = true
	get_tree().paused = true
	level_completed.emit(player.get_global_transform_with_canvas().get_origin())
