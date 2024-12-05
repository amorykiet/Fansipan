extends SubViewportContainer

func _on_world_camera_setted(gameplay_camera: GameplayCamera):
	gameplay_camera.set_viewport_shader(material)
