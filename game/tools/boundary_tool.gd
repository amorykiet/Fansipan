@tool
extends Node2D

@export var room: Room

func _draw():
	if Engine.is_editor_hint():
		draw_rect(room.boundary, Color.GREEN, false)
		room.area.hide()
		
func _process(delta):
	if Engine.is_editor_hint():
		queue_redraw()
		room.position = room.position.snapped(Vector2.ONE * 8)
