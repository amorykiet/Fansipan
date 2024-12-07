class_name GhostTrailEffect
extends Node2D

@export var particles: GPUParticles2D

var sprite: Sprite2D
var player_sprite:= preload("res://game/scenes/trail_sprite.tscn")

func create_trail():
	particles.restart()
	for i in range(3):
		var ghost_sprite: Sprite2D = player_sprite.instantiate()
		ghost_sprite.frame = sprite.frame
		ghost_sprite.scale = sprite.scale
		ghost_sprite.global_position = sprite.global_position
		owner.add_child(ghost_sprite)
		await get_tree().create_timer(0.07).timeout
