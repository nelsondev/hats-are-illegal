extends Light2D

export var SIZE = Vector2(0.9, 1.1)

func _process(delta):
	transform.origin = Game.get_player().transform.origin
	
func _enter_tree():
	burn()
	
func burn():
	texture_scale = rand_range(SIZE.x, SIZE.y)
	if get_tree() != null:
		yield(get_tree().create_timer(rand_range(0.05, 0.1)), "timeout")
		burn()
