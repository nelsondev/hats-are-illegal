extends Sprite

var player = null

func _on_Area2D_body_entered(body):
	if body.is_in_group("player"):
		$AudioStreamPlayer2D.stop()
		$AudioStreamPlayer.play()
		visible = false
		body.disabled = true
		body.display(load("res://tools/axe.png"), [])
		player = body

func _on_AudioStreamPlayer_finished():
	queue_free()
	player.disabled = false
	player.display(null, [ player.get_node("Decals/axe") ])
	get_parent().get_parent().get_node("AudioStreamPlayer").play_theme(37.7)
	get_parent().get_parent().get_node("AudioStreamPlayer").disabled = false
