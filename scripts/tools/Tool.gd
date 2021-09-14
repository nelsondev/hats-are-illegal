extends Area2D

export var TEXTURE: Resource
export var TOOL: Resource
export var SPEED = 50

var direction = Vector2.ZERO
onready var speed = SPEED
var follow = false
var player = null

# Called when the node enters the scene tree for the first time.
func _ready():
	$Sprite.texture = TEXTURE
	
	var x = rand_range(-1, 1)
	var y = rand_range(-1, 1)
	
	direction = Vector2(x, y)
	
func _process(delta):
	if player != null: return
	
	speed = lerp(speed, 0, 0.01)
	get_parent().transform.origin += direction * speed * delta
	
	for body in get_overlapping_bodies():
		if body.is_in_group("player"):
			player = body
			player.display($Sprite.texture)
			$CollisionShape2D.queue_free()
			$AnimatedSprite_Sparkle1.visible = false
			$AnimatedSprite_Sparkle2.visible = false
			$AnimatedSprite_Sparkle3.visible = false
			$Sprite.visible = false
			$AudioStreamPlayer2D.stop()
			$AudioStreamPlayer.play()

func _on_AudioStreamPlayer2D_finished():
	if not $AudioStreamPlayer.playing:
		$AudioStreamPlayer2D.play()

func _on_AudioStreamPlayer_finished():
	player.display_stop(TOOL)
	get_parent().queue_free() 
