extends KinematicBody2D

func _ready():
	$Jacket/AnimationPlayer.play("default")
	$Hat/AnimationPlayer.play("default")
	$Knife/AnimationPlayer.play("default")
	$Grenade/AnimationPlayer.play("default")
	$Head/AnimationPlayer.play("default")
