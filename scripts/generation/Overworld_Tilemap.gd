extends TileMap

const CACTUS = preload("res://scenes/resources/Cactus.tscn")
const SHROOM = preload("res://scenes/resources/Mushroom.tscn")

func generate():
	Game.LOADING_MAP = true
	
	var size = Game.get_map().SIZE

	# Generate default tile
	for y in range(size.y):
		for x in range(size.x):
			var position = Vector2(x, y) * Vector2(8, 8) - Vector2(4, 0)
			var map = world_to_map(position)
			var rand = rand_range(0, 100)
			
			if rand < 10:
				set_cellv(map, 0)
			elif rand < 20:
				set_cellv(map, 1)
			else:
				set_cellv(map, 2)
	
	# Generate grass
	var noise = Game.NOISE[0]

	for y in noise.size():
		var col = noise[y]
		for x in col.size():
			var row = col[x]

			if row < 0: 
				continue
			else:
				var position = Vector2(x, y) * Vector2(8, 8) - Vector2(4, 0)
				var map = world_to_map(position)
				set_cellv(map, 3)
				
				if rand_range(0, 100) <= 5:
					set_cellv(map, 4)
					
				if rand_range(0, 100) <= 0.5:
					set_cellv(map, 5)
					
				if rand_range(0, 100) < 1:
					var shroom = SHROOM.instance()
					get_parent().get_node("Resources").add_child(shroom)
					shroom.transform.origin = position
	
	# Generate sand
	noise = Game.NOISE[1]

	for y in noise.size():
		var col = noise[y]
		for x in col.size():
			var row = col[x]

			if row < 0: 
				continue
			else:
				var position = Vector2(x, y) * Vector2(8, 8) - Vector2(4, 0)
				var map = world_to_map(position)
				var cell = get_cellv(map)
				
				if cell == 3 or cell == 4 or cell == 5: continue
				
				set_cellv(map, 6)
				
				if rand_range(0, 100) <= 2:
					var cactus = CACTUS.instance()
					get_parent().get_node("Resources").add_child(cactus)
					cactus.transform.origin = position
					
		# Generate borders
	for x in range(size.x):
		var y = -1
		var position = Vector2(x, y)
		set_cellv(position, 8)
	for x in range(size.x):
		var y = size.y
		var position = Vector2(x, y)
		set_cellv(position, 8)
	for y in range(size.y):
		var x = -1
		var position = Vector2(x, y)
		set_cellv(position, 8)
	for y in range(size.y):
		var x = size.x - 1
		var position = Vector2(x, y)
		set_cellv(position, 8)
		
	Game.LOADING_MAP = false
