class_name Player
extends CharacterBody2D

@export var sprite: Sprite2D

#region Constants
const HALF_WIDTH: int = 4

const MAX_FALL: float = 160.0
const GRAVITY: float = 900.0
const HALF_GRAV_THRESHOLD: float = 40.0
const FAST_MAX_FALL: float = 240.0
const FAST_MAX_ACCEL: float = 300.0

const MAX_RUN: float = 90.0
const RUN_ACCEL: float = 1000.0
const RUN_REDUCE: float = 400.0
const AIR_MULT: float = 0.65

const JUMP_SPEED: float = -105.0
const JUMP_GRACE_TIME: float = 0.1
const VAR_JUMP_TIME: float = 0.2
const JUMP_H_BOOST: float = 40.0

const WALL_JUMP_CHECK_DIST: int = 3
const WALL_JUMP_FORCE_TIME: float = 0.16
const WALL_JUMP_H_SPEED: float = MAX_RUN + JUMP_H_BOOST

const DUCK_FRICTION: float = 500.0

const WALL_SLIDE_START_MAX: float = 20.0
const WALL_SLIDE_TIME: float = 1.2
const WALL_SLIDE_CHECK_DIST: int = 1

const CLIMB_TIRED_THRESHOLD: float = 20.0
const CLIMB_MAX_STAMINA: float = 110
const CLIMB_CHECK_DIST: int = 2
const CLIMB_GRAB_Y_MULT: float = 0.2
const CLIMB_NO_MOVE_TIME: float = 0.1

#endregion

#region Variables
var stamina: float = CLIMB_MAX_STAMINA

var max_fall: float

var facing: int = 1
var input_move_x: int
var input_move_y: int
var move_x: int
var move_y: int

var jump_grace_timer: float
var var_jump_speed: float
var var_jump_timer: float
var force_move_x: int
var force_move_x_timer: float

var wall_slide_timer: float = WALL_SLIDE_TIME
var wall_slide_dir: int 
var climb_no_move_timer: float

#endregion

#region States
static var normal_state:= NormalState.new()
static var climb_state:= ClimbState.new()
static var dash_state:= DashState.new()
var current_state: State

#endregion

#region Onready
@onready var normal_collision = $NormalCollision as CollisionShape2D
@onready var duck_collision = $DuckCollision as CollisionShape2D
@onready var normal_hurtbox = $NormalHurtbox/CollisionShape2D as CollisionShape2D
@onready var duck_hurtbox = $DuckHurtbox/CollisionShape2D as CollisionShape2D
@onready var unduck_check_box = $UnduckCheckBox as Area2D
#endregion

func _enter_tree():
	current_state = normal_state

func _process(delta):
	queue_redraw()

func _unhandled_input(event):
	if current_state:
		current_state._handle_input(self, event)

func _physics_process(delta):
	# TODO
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
		move_y = 1
	if Input.is_action_just_pressed("ui_up"):
		move_y = -1
	if Input.is_action_just_released("ui_up") and Input.is_action_pressed("ui_down"):
		move_y = 1
	if Input.is_action_just_released("ui_down") and Input.is_action_pressed("ui_up"):
		move_y = -1
	if not Input.is_action_pressed("ui_down") and not Input.is_action_pressed("ui_up"):
		move_y = 0
	
	# force move x
	if force_move_x_timer > 0:
		force_move_x_timer -= delta
		move_x = force_move_x
	else:
		move_x = input_move_x
	# facing
	facing = move_x if move_x != 0 else facing
	
	# jump grace
	if on_ground:
		jump_grace_timer = JUMP_GRACE_TIME
	elif jump_grace_timer > 0:
		jump_grace_timer -= delta
	
	# var jump
	if var_jump_timer > 0:
		var_jump_timer -= delta
	
	# wall slide
	if wall_slide_dir != 0:
		wall_slide_timer = maxf(wall_slide_timer - delta, 0)
		wall_slide_dir = 0
	
	# update state
	if current_state:
		current_state._update(self, delta)
	
	move_and_slide()
	
func change_state(new_state: State):
	if current_state:
		current_state._exit(self)
	current_state = new_state
	current_state._enter(self)

#region NormalState

var on_ground: bool:
	get:
		return is_on_floor()

# NOTE: climb bounds check
func climb_check(dir: int, y_add: int = 0) -> bool:
	return collide_check(Vector2(dir * (HALF_WIDTH + CLIMB_CHECK_DIST), y_add))

#endregion

#region ClimbState

var check_stamina: float:
	get:
		return stamina


var is_tired: bool:
	get:
		return check_stamina < CLIMB_TIRED_THRESHOLD

#endregion

#region Ducking
var ducking: bool:
	get: 
		return normal_collision.disabled or normal_hurtbox.disabled
	set(duck):
		if duck:
			normal_collision.set_deferred("disabled", true)
			normal_hurtbox.set_deferred("disabled", true)
			duck_collision.set_deferred("disabled", false)
			duck_hurtbox.set_deferred("disabled", false)
		else:
			normal_collision.set_deferred("disabled", false)
			normal_hurtbox.set_deferred("disabled", false)
			duck_collision.set_deferred("disabled", true)
			duck_hurtbox.set_deferred("disabled", true)
var can_un_duck: bool:
	get:
		if not ducking:
			return true
		return not unduck_check_box.has_overlapping_bodies()
#endregion

#region Jump

func jump():
	InputBuffer.comsume_action("jump")
	jump_grace_timer = 0
	var_jump_timer = VAR_JUMP_TIME
	wall_slide_timer = WALL_SLIDE_TIME
	
	velocity.y = JUMP_SPEED
	var_jump_speed = velocity.y

func wall_jump_check(dir: int) -> bool:
	return collide_check(Vector2.RIGHT * (HALF_WIDTH + WALL_JUMP_CHECK_DIST) * dir)

func wall_jump(dir: int):
	ducking = false
	InputBuffer.comsume_action("jump")
	jump_grace_timer = 0
	var_jump_timer = VAR_JUMP_TIME
	wall_slide_timer = WALL_SLIDE_TIME
	
	if move_x != 0:
		force_move_x = dir
		force_move_x_timer = WALL_JUMP_FORCE_TIME
	
	# NOTE: Get lift of wall?
	
	velocity.x = WALL_JUMP_H_SPEED * dir
	velocity.y = JUMP_SPEED
	var_jump_speed = JUMP_SPEED
	
	#NOTE: effect
#endregion

func collide_check(target: Vector2) -> bool:
	var space_state = get_world_2d().direct_space_state
	var query = PhysicsRayQueryParameters2D.create(global_position, global_position + target)
	query.exclude = [self]
	var result = space_state.intersect_ray(query)
	return not result.is_empty()
	
	
	
	
	
