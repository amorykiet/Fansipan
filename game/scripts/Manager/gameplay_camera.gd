class_name  GameplayCamera
extends Camera2D

const FOLLOW_TIME: float = 2
var pixel_cam_shader_material: ShaderMaterial
var target: Node2D

func _process(delta : float) -> void:
	if target == null:
		return
	
	#if global_position.distance_to(target.global_position) > 1:
		#global_position = lerp(global_position, target.global_position, 5 * delta)
	global_position.y = Constants.WINDOW_SIZE.y / 2
	
	if abs(global_position.x - target.position.x) > 1:
		global_position.x = lerp(global_position.x, target.global_position.x, 5 * delta)
	
	var actual_pos: Vector2 = global_position
	var sub_pixel : Vector2 = Vector2(
		global_position.round().x - global_position.x,
		global_position.round().y - global_position.y
		)
	if pixel_cam_shader_material:
		pixel_cam_shader_material.set_shader_parameter("cam_offset", sub_pixel)
	pass

func set_target(target_: Node2D):
	target = target_
