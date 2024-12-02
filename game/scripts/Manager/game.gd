extends Node2D

var foreground_world_viewport_container: SubViewportContainer
var gameplay_camera: GameplayCamera
var player: Player


func _ready():
	player = $ForegroundWorld/WorldViewport/World/Delta as Player
	gameplay_camera = $ForegroundWorld/WorldViewport/World/GameplayCamera as GameplayCamera
	foreground_world_viewport_container = $ForegroundWorld as SubViewportContainer
	gameplay_camera.pixel_cam_shader_material = foreground_world_viewport_container.material
	gameplay_camera.set_target(player)
