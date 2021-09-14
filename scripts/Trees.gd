extends StaticBody2D

signal damaged(amount)

export var RESOURCE_NAME = ""
export var RESOURCE_HEALTH = 3
export var RESOURCE_DROP = Vector2(0, 5)
export var RESOURCE_TEXTURES: Array = []
export var RESOURCE_ITEMS: Array = []
export var RESOURCE_HIT_SOUNDS: Array = []
export var RESOURCE_BREAK_SOUNDS: Array = []
export var RESOURCE_WINDY_ANIMATION = false
export var RESOURCE_TEXTURE_OFFSET = Vector2(0, 0)

func _ready():
	get_parent().add_to_group("resource")
	
	_pick_texture()
	_pick_hit_sounds()
	_pick_break_sounds()
	_play_windy_animation()
	
	if RESOURCE_TEXTURE_OFFSET != Vector2.ZERO: 
		$CollisionShape2D.transform.origin += RESOURCE_TEXTURE_OFFSET
		$Sprite.offset = RESOURCE_TEXTURE_OFFSET
	
func _pick_texture():
	$Sprite.texture = RESOURCE_TEXTURES[randi() % RESOURCE_TEXTURES.size()]

func _pick_hit_sounds():
	for sound in RESOURCE_HIT_SOUNDS:
		var audio = AudioStreamPlayer2D.new()
		$Audio_Hit.add_child(audio)
		audio.stream = sound
		audio.bus = "Actions"

func _pick_break_sounds():
	for sound in RESOURCE_BREAK_SOUNDS:
		var audio = AudioStreamPlayer2D.new()
		$Audio_Break.add_child(audio)
		audio.stream = sound
		audio.bus = "Actions"
	
func _play_hit_sounds():
	for audio in $Audio_Hit.get_children():
		audio.pitch_scale = rand_range(0.95, 1.05)
		audio.play()
	
func _play_break_sounds():
	for audio in $Audio_Break.get_children():
		audio.pitch_scale = rand_range(0.95, 1.05)
		audio.play()
	
func _play_windy_animation():
	if RESOURCE_WINDY_ANIMATION:
		yield(get_tree().create_timer(rand_range(0.1, 0.5)), "timeout")
		$AnimationPlayer_Wind.play("wind")
		$AnimationPlayer_Shake.connect("animation_finished", self, "_start_wind")
	
func _drop_items():
	if RESOURCE_ITEMS.size() == 0: return
	
	for i in range(0 + RESOURCE_DROP.x, RESOURCE_DROP.y):
		var item = RESOURCE_ITEMS[randi() % RESOURCE_ITEMS.size()].instance()
		get_node("/root/Zelda/Items").add_child(item)
		item.transform.origin = get_parent().transform.origin
	
func _destroy():
	visible = false
	
	$CollisionShape2D.disabled = true
	$CollisionShape2D.queue_free()
	
	_play_break_sounds()
	_drop_items()
	
	yield(get_tree().create_timer(2.0), "timeout")
	get_parent().queue_free()
	
func _start_wind(_arg):
	if RESOURCE_WINDY_ANIMATION: 
		$AnimationPlayer_Wind.stop(true)
		$AnimationPlayer_Wind.play("wind")
	
func damage(amount):
	RESOURCE_HEALTH -= amount
	
	emit_signal("damaged", amount)
	
	$AnimationPlayer_Wind.stop(true)
	$AnimationPlayer_Shake.stop(true)
	$AnimationPlayer_Shake.play("shake")
	
	_play_hit_sounds()
	
	if RESOURCE_HEALTH <= 0: _destroy()
	
	
