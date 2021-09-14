extends TileMap

func _process(delta):
	var size = Game.get_map().SIZE
	var tm = Game.get_map().get_node("TileMap")
	var player_position = Game.get_player().transform.origin
	var player_position_x = int(player_position.x - (int(player_position.x) % 8))
	var player_position_y = int(player_position.y - (int(player_position.y) % 8))
	var position_world = tm.world_to_map(player_position)
	
	player_position = Vector2(player_position_x, player_position_y)
	
	var player_pos_map = map_to_world(position_world)
	
	# Generate default tile
	for y in range(size.y):
		if y == 0: continue
		if y == size.y - 1: continue
		for x in range(size.x):
			if x == 0: continue
			if x == size.x - 1: continue
			var position = Vector2(x, y)
			
			var cell = tm.get_cellv(position)
			
			set_cellv(position, cell)
	
	print(position_world)
