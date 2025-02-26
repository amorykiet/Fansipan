extends Node2D
@onready var jump_tutorial = $JumpTutorial
@onready var climb_tutorial: Control = $ClimbTutorial
@onready var dash_tutorial: Control = $Dashtutorial
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var screen_black_effect: ColorRect = $ScreenBlackEffect
@onready var open_screen: TextureRect = $OpenScreen
@onready var world = $WorldViewportContainer/WorldViewport/World

var screen_black_effect_mat: ShaderMaterial
var cur_level: Level

func _ready():
	var bird_tutorial_list: Array = get_tree().get_nodes_in_group("BirdTutorial")
	for bird: BirdTutorial in bird_tutorial_list:
		if bird.tutorial_name == "jump":
			bird.tutorial_panel = jump_tutorial
		elif bird.tutorial_name == "climb":
			bird.tutorial_panel = climb_tutorial
		elif bird.tutorial_name == "dash":
			bird.tutorial_panel = dash_tutorial
	
	cur_level = world.cur_level
	cur_level.level_completed.connect(on_complete_level)
	
	screen_black_effect_mat = screen_black_effect.material
	screen_black_effect_mat.set_shader_parameter("position", Vector2(15, 100))
	open_screen.material.set_shader_parameter("position", Vector2(15, 100))
	animation_player.play("open")

func pause():
	get_tree().paused = true
	

func start():
	get_tree().paused = false
	cur_level.start()

func on_complete_level(pos: Vector2):
	screen_black_effect_mat.set_shader_parameter("position", pos)
	animation_player.play("end")
