extends Node2D

var world_viewport_container: SubViewportContainer
var gameplay_camera: GameplayCamera
var player: Player


func _ready():
	player = $WorldViewportContainer/WorldViewport/World/Delta as Player
	gameplay_camera = $WorldViewportContainer/WorldViewport/World/GameplayCamera as GameplayCamera
	world_viewport_container = $WorldViewportContainer as SubViewportContainer
	gameplay_camera.pixel_cam_shader_material = world_viewport_container.material
	gameplay_camera.set_target(player)
