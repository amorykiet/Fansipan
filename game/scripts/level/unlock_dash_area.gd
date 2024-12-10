extends Area2D

@export var player: Player


func _on_body_entered(body):
	player.unlocked_dash = true
