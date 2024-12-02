extends Node2D

const SCREEN_SCALE: float = 4

@onready var world_viewport = $ForegroundWorld/WorldViewport as SubViewport
@onready var foreground_world_viewport_container = $ForegroundWorld as SubViewportContainer
@onready var label = $Label
@onready var gameplay_camera = $ForegroundWorld/WorldViewport/World/GameplayCamera as GameplayCamera


func _ready():
	gameplay_camera.pixel_cam_shader_material = foreground_world_viewport_container.material as ShaderMaterial
