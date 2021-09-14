extends Area2D

export var DAMAGE = 1.0
export var DIRECTION = Vector2.ZERO

func _ready():
	$AnimatedSprite.play("default")
	yield($AnimatedSprite, "animation_finished")
	$CollisionShape2D.disabled = true
	yield(get_tree().create_timer(2.0), "timeout")
	queue_free()
