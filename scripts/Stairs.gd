extends Sprite

func _ready():
	var ran_x = int(rand_range(128, 672))
	var ran_y = int(rand_range(128, 672))
	var ran_x_offset = ran_x - (ran_x % 8)
	var ran_y_offset = ran_y - (ran_y % 8)
	transform.origin = Vector2(ran_x_offset, ran_y_offset)

	if Game.get_map().NAME == "Underworld":
		Game.get_player().set_global_position(Vector2(transform.origin.x, transform.origin.y - 8))

func _on_Area2D_body_entered(body):
	if body.is_in_group("resource"):
		body.queue_free()

func _on_Enter_area_entered(area):
	if not area.is_in_group("slash"): return
	Game.LOADING = true
	Game.get_interface().get_node("Loading").visible = true
	if Game.get_map().NAME == "Overworld":
		var game = Game.get_game()
		var level = game.LEVELS["Underworld"]
		game.level(level)
		yield(get_tree().create_timer(0.5), "timeout")
		var position = Game.get_map().get_node("STAIRS").get_global_position()
		Game.get_player().set_global_position(position)
	else:
		var game = Game.get_game()
		var level = game.LEVELS["Overworld"]
		game.level(level)
		yield(get_tree().create_timer(0.5), "timeout")
		var position = Game.get_map().get_node("STAIRS").get_global_position()
		Game.get_player().set_global_position(position)
	Game.get_interface().get_node("Loading").visible = false
