extends KinematicBody2D

export var RESOURCES = {
	"wood": 0
}
export var disabled = false
var holding_block = false
var holding_tool = null

const SLASH = preload("res://scenes/Slash.tscn")
const WOOD_BLOCK = preload("res://scenes/Block.tscn")

func _ready():
	$Camera2D.current = get_parent().visible
#	$Decals/Light2D/AnimationPlayer.play("fade")
#	$Tool.set_tool(load("res://scenes/player/Axe.tscn").instance())

func _physics_process(delta):
	if disabled: 
		$AudioStreamPlayer_Step1/AnimationPlayer.stop()
		$AudioStreamPlayer_Step1.stop()
		$Decals/Hat/AnimationPlayer.play("default")
		if $Tool.get_tool_animation() != null:
			$Tool.get_tool_animation().play("default")
		$AnimatedSprite.play("default")
		return
	
	$Input.start($Movement, self, 1)
	
	if $Movement.is_moving(): 
		$AnimatedSprite.play("walk")
	else: 
		$AnimatedSprite.play("default")
	
	if $Movement.is_moving():
		$Decals/Hat/AnimationPlayer.play("walk")
		if $Tool.get_tool_animation() != null:
			$Tool.get_tool_animation().play("walk")
	else:
		$Decals/Hat/AnimationPlayer.play("default")
		if $Tool.get_tool_animation() != null:
			$Tool.get_tool_animation().play("default")
		
	if $Movement.get_direction() == "left":
		$AnimatedSprite.flip_h = true
		$Decals/Hat.flip_h = true
	elif $Movement.get_direction() == "right":
		$AnimatedSprite.flip_h = false
		$Decals/Hat.flip_h = false
		
	if $Movement.is_moving():
		$AudioStreamPlayer_Step1/AnimationPlayer.play("step")
	else:
		$AudioStreamPlayer_Step1/AnimationPlayer.stop()
		
	var position = Vector2.ZERO
	
#	if holding_block:
#		$Decals/select.visible = true
#
#		var direction = $Input.last
#		var offset = direction * 10
#		position = transform.origin + offset
#		position = position.round()
#
#		if int(position.x) % 8 != 0:
#			position.x -= int(position.x) % 8
#		if int(position.y) % 8 != 0:
#			position.y -= int(position.y) % 8
#
#		$Decals/select.set_global_position(position)
#	else:
#		$Decals/select.visible = false
	
#	if Input.is_action_just_pressed("item_left"):
#		holding_block = !holding_block
	
	if Input.is_action_just_pressed("use"):
		$AudioStreamPlayer.pitch_scale = rand_range(0.8, 1.2)
		$AudioStreamPlayer.play()
		$Camera2D.shake(2.5, 0.1)
		var slash = SLASH.instance()
		var direction = $Input.last
		var offset = direction * 18
		slash.connect("body_entered", self, "hit")
		get_parent().add_child(slash)
		slash.DIRECTION = direction
		slash.get_node("AnimatedSprite").flip_h = true if $Movement.get_direction() == "left" else false
		slash.set_global_position(get_global_position() + offset)

func hit(body):
	if not body.is_in_group("damagable") \
		or body.is_in_group("player"): return
	
	if body.is_in_group("resource"):
		var damage = $Tool.get_resource_damage(body)
		body.damage(damage)
	else:
		var damage = $Tool.get_enemy_damage()
		body.damage(damage)

func damage(amount, direction):
	Game.HEALTH -= amount
	
	if Game.HEALTH <= 0:
		disabled = true
		Game.get_game().level(Game.get_game().LEVELS["Overworld"])
		get_tree().reload_current_scene()
		Game.HEALTH = 1.5
		Game.RESOURCES = {
			"wood": 0,
			"slime": 0,
			"iron": 0,
			"stone": 0,
			"heart": 0
		}
		Game.INVENTORY = []
		return
	
	disabled = true
	$Movement.move(self, direction, 15.0)
	$Camera2D.shake(5.0, 0.1)
	$AudioStreamPlayer_Damage1.play()
	$AudioStreamPlayer_Damage2.play()
	yield(get_tree().create_timer(0.5), "timeout")
	disabled = false

func display(texture):
	$Decals/Display.texture = texture
	$Decals/Display.visible = true
	disabled = true
	
func display_stop(item):
	Game.INVENTORY.push_back(item)
	$Tool.set_tool(item.instance())
	$Decals/Display.visible = false
	disabled = false
	Game.get_map().get_node("AudioStreamPlayer_Music").play(37)
