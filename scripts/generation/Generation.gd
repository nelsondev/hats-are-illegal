extends Node

func noise(width, height, octaves = 30, period = 40, persistence = 0.8, seed_offset = 0):
	var noise = OpenSimplexNoise.new()
	
	seed(OS.get_unix_time() + seed_offset)
	
	noise.seed = randi()
	noise.octaves = octaves
	noise.period = period
	noise.persistence = persistence

	var cols = []
	
	for y in range(height):
		var row = []
		for x in range(width):
			row.push_back(noise.get_noise_2d(x, y))
		cols.push_back(row)
		
	return cols
