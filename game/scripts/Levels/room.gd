class_name Room
extends Node2D

signal player_entered(room: Room)

@export var boundary: Rect2i
@export var area: CollisionShape2D

var center: Vector2

func _ready():
	area.shape.size = boundary.size - Vector2i.ONE 
	area.position = boundary.size/2
	center = global_position + Vector2(boundary.size/2)

func _on_room_area_body_entered(body: Node2D):
	player_entered.emit(self)
