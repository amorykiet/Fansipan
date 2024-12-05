extends Node2D
signal camera_setted(gameplay_camera: GameplayCamera)

@onready var gameplay_camera:= $GameplayCamera as GameplayCamera

func _process(delta):
	if gameplay_camera.viewport_shader == null:
		camera_setted.emit(gameplay_camera)
