class_name Room
extends Node2D

signal player_entered(room: Room)

@export var boundary: Rect2i
@export var area: CollisionShape2D


func _ready():
	area.shape.size = boundary.size
	area.position = boundary.size/2

func _on_room_area_body_entered(body: Node2D):
	player_entered.emit(self)
