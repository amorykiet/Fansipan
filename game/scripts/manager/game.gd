extends Node2D
@onready var jump_tutorial: Control = $JumpTutorial
@onready var climb_tutorial = $ClimbTutorial
@onready var dash_tutorial = $Dashtutorial

func _ready():
	var bird_tutorial_list: Array = get_tree().get_nodes_in_group("BirdTutorial")
	for bird: BirdTutorial in bird_tutorial_list:
		bird.tutorial_done.connect(on_tutorial_done)
		if bird.tutorial_name == "jump":
			bird.tutorial_panel = jump_tutorial
		elif bird.tutorial_name == "climb":
			bird.tutorial_panel = climb_tutorial
		elif bird.tutorial_name == "dash":
			bird.tutorial_panel = dash_tutorial
func on_tutorial_done(tutorial_name: String):
	#match tutorial_name:
		#"jump":
			#jump_tutorial.hide()
	pass
