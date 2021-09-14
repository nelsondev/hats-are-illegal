extends YSort

const SLIME = preload("res://scenes/Slime.tscn")

func _on_Timer_timeout():
	if get_children().size() > Game.ENTITY_SIZE: return
	$Timer.wait_time -= 0.05
	var size = Game.MAP_SIZE
	var ran_x = int(rand_range(64, 336))
	var ran_y = int(rand_range(64, 336))
	var ran_x_offset = ran_x - (ran_x % 8)
	var ran_y_offset = ran_y - (ran_y % 8)
	var slime = SLIME.instance()
	add_child(slime)
	slime.transform.origin = Vector2(ran_x_offset, ran_y_offset)
