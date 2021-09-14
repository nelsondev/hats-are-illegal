extends Node

signal loaded()

var RESOURCES = {
	"heart": 0,
	"wood": 0,
	"stone": 0,
	"iron": 0,
	"slime": 0
}
var INVENTORY = []
var HEALTH = 1.5
var ENTITY_SIZE = 64
var LOADING = true
var LOADING_MAP = true
var LOADING_RESOURCES = true
const MAP_SIZE = Vector2(100, 100)
onready var NOISE = [
	Generation.noise(100, 100, 1, 20, 10),
	Generation.noise(100, 100, 1, 20, 10, 20),
	Generation.noise(100, 100, 10, 50, 10),
	Generation.noise(50, 50, 1, 20, 10),
	Generation.noise(50, 50, 10, 50, 10),
]

func generate_noise(width, height, octaves = 30, period = 40, persistence = 0.8):
	var noise = OpenSimplexNoise.new()
	
	seed(OS.get_unix_time())
	
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

func _ready():
	pause_mode = Node.PAUSE_MODE_PROCESS
#	get_tree().paused = LOADING

func _process(delta):
	LOADING = LOADING_MAP or LOADING_RESOURCES
	
	if RESOURCES["heart"] > 0:
		var amount = RESOURCES["heart"] / 2.0
		
		if HEALTH + amount > 3:
			HEALTH = 3
		else:
			HEALTH += amount
		
		print(HEALTH)
			
		RESOURCES["heart"] = 0

	
func get_game():
	return get_node("/root/Zelda")
	
func get_player():
	return get_node("/root/Zelda/player_1")	

func get_map():
	if get_node("/root/Zelda/Map").get_children().size() == 0: return null
	return get_node("/root/Zelda/Map").get_children()[0]

func get_interface():
	return get_node("/root/Zelda/Interface")
	
func get_camera():
	return get_player().get_node("Camera2D")
