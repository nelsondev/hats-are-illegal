extends Area2D

export var SPEED = 100
export var TEXTURE: Resource
export var NAME = ""

var direction = Vector2.ZERO
onready var speed = SPEED
var follow = false

# Called when the node enters the scene tree for the first time.
func _ready():
	connect("body_entered", self, "_on_Item_body_entered")
	
	$Sprite.texture = TEXTURE
	
	var x = rand_range(-1, 1)
	var y = rand_range(-1, 1)
	
	direction = Vector2(x, y)
	
	yield(get_tree().create_timer(2.0), "timeout")
	
	follow = true
	speed = SPEED * 10
	
func _process(delta):
	if not follow:
		speed = lerp(speed, 0, 0.01)
		get_parent().transform.origin += direction * speed * delta
	else:
		var player = get_node("/root/Zelda/player_1")
		direction = get_parent().transform.origin.direction_to(player.transform.origin)
		get_parent().transform.origin += direction * speed * delta

func _on_Item_body_entered(body):
	if body.is_in_group("player"):
		Game.RESOURCES[NAME] += 1
		$AudioStreamPlayer.pitch_scale = rand_range(0.8, 1.2)
		$AudioStreamPlayer.play()
		yield($AudioStreamPlayer, "finished")
		get_parent().queue_free()
