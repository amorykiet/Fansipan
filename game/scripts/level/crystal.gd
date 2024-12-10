extends Area2D

const RECHARGE_TIME: float = 5.0

@onready var collision = $CollisionShape2D as CollisionShape2D

var recharge_timer: float

func _on_body_entered(body: Node2D):
	if body is Player:
		var player: Player = body as Player
		collision.set_deferred("disabled", true)
		hide()
		player.refill_full()
		recharge_timer = RECHARGE_TIME

func _process(delta):
	if recharge_timer > 0:
		recharge_timer -= delta
	elif collision.disabled:
		show()
		collision.set_deferred("disabled", false)
