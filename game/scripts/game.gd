extends Node

const SCREEN_SCALE: float = 4

@onready var player = $ForegroundWorld/WorldViewport/World/Delta as Player

@onready var player_sprite = $PlayerSprite as Sprite2D



# Called when the node enters the scene tree for the first time.
func _ready():
	player_sprite.scale *= SCREEN_SCALE


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	player_sprite.position.x = round(player.position.x) * SCREEN_SCALE
	player_sprite.position.y = player.position.y * SCREEN_SCALE
	player_sprite.scale.x = player.facing * SCREEN_SCALE
