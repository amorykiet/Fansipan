class_name InputMove
extends Node2D

static var input_move_x: int
static var input_move_y: int

func _physics_process(delta):
	# input_move_x
	if Input.is_action_just_pressed("ui_right"):
		input_move_x = 1
	if Input.is_action_just_pressed("ui_left"):
		input_move_x = -1
	if Input.is_action_just_released("ui_left") and Input.is_action_pressed("ui_right"):
		input_move_x = 1
	if Input.is_action_just_released("ui_right") and Input.is_action_pressed("ui_left"):
		input_move_x = -1
	if not Input.is_action_pressed("ui_left") and not Input.is_action_pressed("ui_right"):
		input_move_x = 0
	
	# move_y
	if Input.is_action_just_pressed("ui_down"):
		input_move_y = 1
	if Input.is_action_just_pressed("ui_up"):
		input_move_y = -1
	if Input.is_action_just_released("ui_up") and Input.is_action_pressed("ui_down"):
		input_move_y = 1
	if Input.is_action_just_released("ui_down") and Input.is_action_pressed("ui_up"):
		input_move_y = -1
	if not Input.is_action_pressed("ui_down") and not Input.is_action_pressed("ui_up"):
		input_move_y = 0
