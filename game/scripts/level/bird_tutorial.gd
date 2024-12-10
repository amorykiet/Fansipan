class_name BirdTutorial
extends Sprite2D

signal tutorial_done(name: String)

enum BirdState {
	IDLE,
	FLY
}

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var tutorial_done_area = $TutorialDoneArea


@export var dir: Vector2
@export var speed: float
@export var tutorial_name: String

var eating_timer: float = 0
var state: BirdState
var tutorial_panel: Control
var on_screen: bool = false

func _ready():
	state = BirdState.IDLE
	change_anim("idle")

func _process(delta):
	if state == BirdState.IDLE:
		if eating_timer > 0:
			eating_timer -= delta
		else:
			eating_timer = randf_range(3.0, 6.0)
			change_anim("eating")
			animation_player.animation_set_next("eating", "idle")
	elif state == BirdState.FLY:
		change_anim("fly")
		dir = dir.normalized()
		position += dir * speed
		flip_h = dir.x > 0
func change_anim(anim: String):
	if animation_player.current_animation != anim:
		animation_player.play(anim)


func _on_tutorial_done_body_entered(body):
	if state != BirdState.FLY:
		state = BirdState.FLY
		if tutorial_panel.visible:
			tutorial_panel.hide()
		tutorial_done.emit(tutorial_name)


func _on_visible_on_screen_notifier_2d_screen_exited():
	on_screen = false
	tutorial_panel.hide()
	if state == BirdState.FLY:
		queue_free()


func _on_visible_on_screen_notifier_2d_screen_entered():
	on_screen = true
	await get_tree().create_timer(2).timeout
	if state == BirdState.IDLE and on_screen:
		tutorial_panel.show()
