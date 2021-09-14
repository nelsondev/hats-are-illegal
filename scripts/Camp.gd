extends Area2D

func _ready():
	var ran_x = int(rand_range(128, 672))
	var ran_y = int(rand_range(128, 672))
	var ran_x_offset = ran_x - (ran_x % 8)
	var ran_y_offset = ran_y - (ran_y % 8)
	transform.origin = Vector2(ran_x_offset, ran_y_offset)
	
	Game.get_player().set_global_position($Spawn.get_global_position())

func _on_Camp_body_entered(body):
	if body.is_in_group("resource"):
		body.queue_free()

func _on_Crafting_area_entered(area):
	if area.is_in_group("slash"):
		Game.get_interface().open_crafting()
