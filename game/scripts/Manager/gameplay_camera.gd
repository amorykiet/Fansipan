class_name  GameplayCamera
extends Camera2D

var viewport_shader: ShaderMaterial

var target: Node2D
var offset_: Vector2
var smooth_speed: float = 10.0

var up_limit: int
var down_limit: int
var left_limit: int
var right_limit: int

var changing_room: bool = false
var started: bool = false

func _ready():
	global_position = Vector2.ZERO
	
func _process(delta) -> void:
	if target == null or not enabled or not started: 
		return
	
	# set target position
	var offset_target: Vector2 = target.global_position + offset_
	var new_pos: Vector2
	new_pos.x = clamp(offset_target.x,\
			left_limit + Constants.WINDOW_SIZE.x/2,\
			right_limit - Constants.WINDOW_SIZE.x/2)
	new_pos.y = clamp(offset_target.y,\
			up_limit + Constants.WINDOW_SIZE.y/2,\
			down_limit - Constants.WINDOW_SIZE.y/2)
	new_pos = new_pos + Vector2.ONE
	var temp_pos:= global_position
	if temp_pos.distance_to(new_pos) > 0.5:
		temp_pos = lerp(temp_pos, new_pos, smooth_speed * delta)
	else:
		temp_pos = new_pos
		if changing_room:
			changing_room = false
	
	
	global_position = temp_pos
	
	var sub_pixel : Vector2 = Vector2(
		global_position.round().x - global_position.x,
		global_position.round().y - global_position.y
		)
	
	if sub_pixel.length() < 0.1:
		sub_pixel = Vector2.ZERO
	
	if viewport_shader:
		viewport_shader.set_shader_parameter("cam_offset", sub_pixel)

func set_target(target_: Node2D, smooth_speed: float = 5.0, offset_: Vector2 = Vector2.ZERO) -> GameplayCamera:
	self.offset_ = offset_
	target = target_
	self.smooth_speed = smooth_speed
	return self

func set_room(room: Room) -> GameplayCamera:
	var boundary_:= room.boundary
	up_limit = boundary_.position.y + room.position.y
	down_limit = boundary_.position.y + boundary_.size.y + room.position.y
	left_limit = boundary_.position.x + room.position.x
	right_limit = boundary_.position.x + boundary_.size.x + room.position.x
	changing_room = true
	return self

func set_smooth_speed(speed: float) -> GameplayCamera:
	smooth_speed = speed
	return self

func set_viewport_shader(shader: ShaderMaterial):
	viewport_shader = shader
