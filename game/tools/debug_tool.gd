@tool
extends Node2D

@export var player: Player

func _draw():
	draw_line(player.global_position + Vector2.DOWN, player.global_position + Vector2.UP, Color.AQUA)
	draw_line(player.global_position + Vector2.LEFT, player.global_position + Vector2.RIGHT, Color.AQUA)

func _process(delta):
	if not Engine.is_editor_hint():
		queue_redraw()
