extends Node

@export var start_room: Room
@export var gameplay_camera: GameplayCamera
@export var player: Player

func _ready():
	gameplay_camera.global_position = Constants.WINDOW_SIZE/2
	gameplay_camera.set_room_boundary(start_room.boundary).set_target(player, 10)
	gameplay_camera.enabled = true
