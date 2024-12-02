class_name Player
extends CharacterBody2D

@onready var sprite = $Sprite as Sprite2D

#region Constants
const HALF_WIDTH: int = 4
const HEAD_HEIGHT: int = 5
const FOOT_HEIGHT: int = 6

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
const CELLING_VAR_JUMP_GRACE: float = 0.05
const UPWARD_CORNER_CORRECTION: int = 4

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
const CLIMB_JUMP_COST: float = 110.0 / 4.0
const CLIMB_JUMP_BOOST_TIME: float = 0.2
const CLIMB_UP_SPEED: float = -45.0
const CLIMB_DOWN_SPEED: float = 80.0
const CLIMB_ACCEL: float = 900.0
const CLIMB_HOP_Y: float = -120.0
const CLIMB_HOP_X: float = 100.0
const CLIMB_HOP_FORCE_TIME: float = 0.2
const CLIMB_SLIP_SPEED: float = 30.0
const CLIMB_UP_COST: float = 100.0 / 2.2
const CLIMB_STILL_COST: float = 100.0 / 10.0

const DASH_COOLDOWN: float = 0.2
const DASH_REFILL_COOLDOWN: float = 0.1
const DASH_SPEED: float = 240.0
const DASH_TIME: float = 0.15
const END_DASH_SPEED: float = 160.0
const END_DASH_UP_MULT: float = 0.75

const DODGE_SLIDE_SPEED_MULT: float = 1.2
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
var hop_wait_x: int
var hop_wait_x_speed: int

var wall_slide_timer: float = WALL_SLIDE_TIME
var wall_slide_dir: int 
var climb_no_move_timer: float
var wall_boost_dir: int
var wall_boost_timer: float
var last_climb_move: int

var dashes: int = 1
var last_aim: Vector2
var dash_cooldown_timer: float
var dash_refill_cooldown_timer: float
var dash_started_on_ground: bool
var before_dash_speed: Vector2
var lastest_dash_speed: Vector2
var dash_dir: Vector2
var collision_on_dash: KinematicCollision2D

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


func _unhandled_input(event):
	if current_state:
		current_state._handle_input(self, event)


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
	# NOTE: in control?
	if move_x != 0 and current_state != climb_state: 
		facing = move_x
	
	# last_aim
	if move_x == 0 and move_y == 0:
		last_aim = Vector2.RIGHT * facing
	else:
		last_aim = Vector2(move_x, move_y).normalized()
	
	# climb hop wait
	if hop_wait_x != 0:
		if signf(velocity.x) == -hop_wait_x or velocity.y > 0:
			hop_wait_x = 0
		elif not collide_check(Vector2((HALF_WIDTH + 0.5) * hop_wait_x, 6)):
			velocity.x = hop_wait_x_speed
			hop_wait_x = 0
	
	# wall slide
	if wall_slide_dir != 0:
		wall_slide_timer = maxf(wall_slide_timer - delta, 0)
		wall_slide_dir = 0
	
	# wall boost
	if wall_boost_timer > 0:
		wall_boost_timer -= delta
		if move_x == wall_boost_dir:
			velocity.x = WALL_JUMP_H_SPEED * move_x
			stamina += CLIMB_JUMP_COST
			wall_boost_timer = 0
		
	# refill to climb
	if on_ground and current_state != climb_state:
		stamina = CLIMB_MAX_STAMINA
		wall_slide_timer = WALL_SLIDE_TIME
	
	# jump grace
	if on_ground:
		jump_grace_timer = JUMP_GRACE_TIME
	elif jump_grace_timer > 0:
		jump_grace_timer -= delta
	
	# dashes
	if dash_cooldown_timer > 0:
		dash_cooldown_timer -= delta
	if dash_refill_cooldown_timer > 0:
		dash_refill_cooldown_timer -= delta
	elif on_ground:
		refill_dash()
	
	# var jump
	if var_jump_timer > 0:
		var_jump_timer -= delta

	
	# update state
	if current_state:
		current_state._update(self, delta)
	
	# correct up corner
	if not collide_check(Vector2.UP * (HEAD_HEIGHT + 1)) and(\
			collide_check(Vector2(HALF_WIDTH, -(HEAD_HEIGHT + 1))) or\
			collide_check(Vector2(-HALF_WIDTH, -(HEAD_HEIGHT + 1)))):
		correct_up_corner()
		
	# move
	move_and_slide()
	sprite.scale.x = facing
	sprite.global_position.y = ceil(global_position.y)
	sprite.global_position.x = round(global_position.x)


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

func climb_hop():
	hop_wait_x = facing
	hop_wait_x_speed = CLIMB_HOP_X * facing
	velocity.y = minf(velocity.y, CLIMB_HOP_Y)
	force_move_x = 0
	force_move_x_timer = CLIMB_HOP_FORCE_TIME

#endregion

#region DashState

var can_dash: bool:
	get:
		return InputBuffer.is_action_press_buffered("dash") and\
				dash_cooldown_timer <= 0 and dashes > 0

func refill_dash():
	# NOTE: if having more dash?
	dashes = 1

func start_dash():
	# NOTE: if having more dash?
	dashes = 1
	dashes = max(0, dashes - 1)
	InputBuffer.comsume_action("dash")
	change_state(dash_state)


func correct_h_dash():
	var x_ : float = (HALF_WIDTH + 1) * sign(dash_dir.x)
	# snap above
	if collide_check(Vector2(x_, FOOT_HEIGHT)):
		for i in range(1, FOOT_HEIGHT + 1):
			if not collide_check(Vector2(x_, FOOT_HEIGHT - i)):
				position.y -= i
				position.x += sign(dash_dir.x)
				velocity = lastest_dash_speed
				return
	# snap below
	elif collide_check(Vector2(x_ , - HEAD_HEIGHT)):
		for i in range(1, HEAD_HEIGHT + 1,):
			if not collide_check(Vector2(x_, - HEAD_HEIGHT + i)):
				position.y += i
				position.x += sign(dash_dir.x)
				velocity = lastest_dash_speed
				return

func correct_up_dash():
	if velocity.x <= 0 and collide_check(Vector2(HALF_WIDTH, - HEAD_HEIGHT - 1)):
		for i in range(1, UPWARD_CORNER_CORRECTION + 1):
			if not collide_check(Vector2(HALF_WIDTH - i, - HEAD_HEIGHT - 1)):
				position.x -= i
				position.y -= 1
				velocity = lastest_dash_speed
				break
	if velocity.x >= 0 and collide_check(Vector2(-HALF_WIDTH, - HEAD_HEIGHT - 1)):
		for i in range(1, UPWARD_CORNER_CORRECTION + 1):
			if not collide_check(Vector2(i - HALF_WIDTH, - HEAD_HEIGHT - 1)):
				position.x += i
				position.y -= 1
				velocity = lastest_dash_speed
				break

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
	wall_boost_timer = 0
	
	velocity.y = JUMP_SPEED
	velocity.x += JUMP_H_BOOST * move_x
	var_jump_speed = velocity.y

func wall_jump_check(dir: int) -> bool:
	return collide_check(Vector2.RIGHT * (HALF_WIDTH + WALL_JUMP_CHECK_DIST) * dir)

func wall_jump(dir: int):
	ducking = false
	InputBuffer.comsume_action("jump")
	jump_grace_timer = 0
	var_jump_timer = VAR_JUMP_TIME
	wall_slide_timer = WALL_SLIDE_TIME
	wall_boost_timer = 0
	
	if move_x != 0:
		force_move_x = dir
		force_move_x_timer = WALL_JUMP_FORCE_TIME
	
	# NOTE: Get lift of wall?
	
	velocity.x = WALL_JUMP_H_SPEED * dir
	velocity.y = JUMP_SPEED
	var_jump_speed = JUMP_SPEED
	
	#NOTE: effect

func climb_jump():
	if not on_ground:
		stamina -= CLIMB_JUMP_COST
	jump()
	
	if move_x == 0:
		wall_boost_dir = -facing
		wall_boost_timer = CLIMB_JUMP_BOOST_TIME
	
	
#endregion

#region Physic

func collide_check(target: Vector2, layer_mask: int = LayerNames.PHYSICS_2D.SOLID_FOREGROUND, position_: Vector2 = global_position) -> bool:
	var space_state = get_world_2d().direct_space_state
	var query = PhysicsRayQueryParameters2D.create(position_, position_ + target, layer_mask)
	query.exclude = [self]
	var result = space_state.intersect_ray(query)
	return not result.is_empty()

func correct_up_corner():
	if velocity.y < 0 and current_state != dash_state:
		if velocity.x <= 0 and not collide_check(Vector2(-HALF_WIDTH, - HEAD_HEIGHT - 1)):
			for i in range(UPWARD_CORNER_CORRECTION):
				if collide_check(Vector2(HALF_WIDTH - i, - HEAD_HEIGHT - 1)):
					position.x -= i
					position.y -= 1
		elif velocity.x >= 0 and not collide_check(Vector2(HALF_WIDTH, - HEAD_HEIGHT - 1)):
			for i in range(UPWARD_CORNER_CORRECTION):
				if collide_check(Vector2(i - HALF_WIDTH, - HEAD_HEIGHT - 1)):
					position.x += i
					position.y -= 1
	
	if(var_jump_timer < VAR_JUMP_TIME - CELLING_VAR_JUMP_GRACE):
		var_jump_timer = 0

#endregion
