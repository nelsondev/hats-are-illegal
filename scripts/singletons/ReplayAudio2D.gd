extends AudioStreamPlayer2D

export var RANGE = Vector2(0, 0)
export var PITCH_RANGE = Vector2(0, 0)

func _on_AudioStreamPlayer_Noise_finished():
	yield(get_tree().create_timer(rand_range(RANGE.x, RANGE.y)), "timeout")
	pitch_scale = rand_range(PITCH_RANGE.x, PITCH_RANGE.y)
	play()
