extends AudioStreamPlayer

export var RANGE = Vector2(0, 0)

func _enter_tree():
	play_random()
	connect("finished", self, "play_random")
	
func play_random(from = 0.0):
	if get_tree() == null: return
	yield(get_tree().create_timer(rand_range(RANGE.x, RANGE.y)), "timeout")
	if playing: 
		play_random()
		return
	play(from)
