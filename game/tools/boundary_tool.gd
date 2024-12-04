@tool
extends Node2D

@export var room: Room
var drawing: bool = false

func _draw():
	if Engine.is_editor_hint() and not drawing:
		draw_rect(room.boundary, Color.GREEN, false)

func _process(delta):
	if Engine.is_editor_hint():
		queue_redraw()
		room.position = room.position.snapped(Vector2.ONE * 8)
