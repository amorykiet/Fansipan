extends Node

const SCREEN_SCALE: float = 4

@onready var player = $ForegroundWorld/WorldViewport/World/Delta as Player
@onready var player_sprite = $PlayerSprite as Sprite2D
@onready var world_viewport = $ForegroundWorld/WorldViewport as SubViewport
@onready var world = $ForegroundWorld/WorldViewport/World as Node2D
@onready var world_camera_2d = $ForegroundWorld/WorldViewport/World/Delta/WorldCamera2D as Camera2D


# Called when the node enters the scene tree for the first time.
func _ready():
	player_sprite.scale *= SCREEN_SCALE


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("ui_accept"):
		#camera_2d.enabled = not camera_2d.enabled
		world_camera_2d.enabled = not world_camera_2d.enabled
	
	player_sprite.position.x = player.position.x * SCREEN_SCALE
	player_sprite.position.y = player.position.y * SCREEN_SCALE
	player_sprite.scale.x = player.facing * SCREEN_SCALE
	
	world.position
	
	
	if world_camera_2d.enabled:
		#player_sprite.position = world_camera_2d.get_screen_center_position() * SCREEN_SCALE
		player_sprite.position = Vector2.ONE * SCREEN_SCALE + world_camera_2d.get_screen_center_position() * SCREEN_SCALE
		if world_camera_2d.get_screen_center_position() == player.position:
			print("true")
