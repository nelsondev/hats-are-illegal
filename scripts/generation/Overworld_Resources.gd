extends YSort

const TREE = preload("res://scenes/resources/Tree.tscn")

func generate():
	Game.LOADING_RESOURCES = true
	var ground_map = get_node("../TileMap")
	var size = Game.MAP_SIZE
	var noise = Game.NOISE[2]

	for y in noise.size():
		var col = noise[y]
		for x in col.size():
			var row = col[x]

			if row < 0: 
				continue
			else:
				var position = Vector2(x, y) * Vector2(8, 8) - Vector2(4, -8)
				var map_position = ground_map.world_to_map(position)
				var cell = ground_map.get_cellv(map_position)
				
				if cell != 3: continue
				
				var tree = TREE.instance()
				add_child(tree)
				tree.transform.origin = position
	
	Game.LOADING_RESOURCES = false
