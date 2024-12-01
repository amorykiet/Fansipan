# TEST
extends Node2D
@onready var player = $Delta as Player

var dir: Vector2

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _draw():
	draw_line(player.position, player.position + dir, Color.RED)

func _process(delta):
	queue_redraw()

func change_dir(dir: Vector2):
	self.dir = dir
