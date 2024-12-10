class_name CheckPoint
extends Area2D

signal player_entered(pos: Vector2)
@onready var sprite_2d = $Sprite2D

func _ready():
	sprite_2d.hide()

func _on_player_entered(body):
	player_entered.emit(global_position)
