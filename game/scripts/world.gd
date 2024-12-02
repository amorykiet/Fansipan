# TEST
extends Node2D
@onready var player = $Delta as Player
@onready var gameplay_camera = $GameplayCamera as GameplayCamera

func _ready():
	gameplay_camera.player = player

#func _draw():
	#draw_line(player.position, player.position + dir, Color.RED)
#
#func _process(delta):
	#queue_redraw()
