class_name  GameplayCamera
extends Camera2D

const FOLLOW_TIME: float = 2

var pixel_cam_shader_material: ShaderMaterial
var player: Player
var follow_timer: float = 0

func _process(delta : float) -> void:
	if global_position.distance_to(player.global_position) > 1:
		global_position = lerp(global_position, player.global_position, 5 * delta)
	
	var actual_pos: Vector2 = global_position
	var sub_pixel : Vector2 = Vector2(
		global_position.round().x - global_position.x, 
		global_position.round().y - global_position.y
		)
	if pixel_cam_shader_material:
		pixel_cam_shader_material.set_shader_parameter("cam_offset", sub_pixel)
	#global_position = actual_pos.round()
