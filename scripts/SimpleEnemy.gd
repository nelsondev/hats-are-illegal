extends KinematicBody2D

export var TARGET_DISTANCE = 80
export var TARGET_ATTACK_DISTANCE = 25
export var MOVE_SPEED = 20
export var ATTACK_SPEED = 75
export var ATTACK_LENGTH = 0.8
export var HEALTH = 5.0
export var ATTACK_STRENGTH = 0.5

var ITEM = preload("res://scenes/items/Slime.tscn")

var target: Node2D = null
var target_lock: Vector2 = Vector2.ZERO
var charging = false
var attacking = false
var disabled = false

func _ready():
	$Movement.SPEED = MOVE_SPEED
	$AnimatedSprite.play("spawn")
	disabled = true
	yield($AnimatedSprite, "animation_finished")
	disabled = false

func _physics_process(delta):
	if disabled: 
		charging = false
		attacking = false
		target = null
		target_lock = Vector2.ZERO
		return
	
	if target: 
		seek_target()
	else: 
		find_target()

func seek_target():
	var enemy_position = get_position()
	var target_position = target.get_position()
	var distance = enemy_position.distance_to(target_position)
	var direction = enemy_position.direction_to(target_position)
	
	if $Movement.get_direction(direction.round()) == "left":
		$AnimatedSprite.flip_h = true
	elif $Movement.get_direction(direction.round()) == "right":
		$AnimatedSprite.flip_h = false
	
	if charging: return
	if attacking:
		if not $AudioStreamPlayer_Noise.playing:
			$AudioStreamPlayer_Noise.pitch_scale = 1.5
			$AudioStreamPlayer_Noise.play()
		$Movement.SPEED = ATTACK_SPEED
		$Movement.move(self, target_lock)
		return
	
	if distance >= TARGET_ATTACK_DISTANCE:
		$Movement.SPEED = MOVE_SPEED
		$Movement.move(self, direction)
		$AnimatedSprite.play("default")
	else:
		charging = true
		target_lock = direction
		$AnimatedSprite.play("charge")
		yield($AnimatedSprite, "animation_finished")
		$AnimatedSprite.play("attack")
		charging = false
		attacking = true
		yield(get_tree().create_timer(ATTACK_LENGTH), "timeout")
		attacking = false
		target_lock = Vector2.ZERO
		
	if distance >= TARGET_DISTANCE: target = null

func find_target():
	$AnimatedSprite.play("default")
	var node = Game.get_player()
	var target_position = node.get_position()
	var slime_position = self.get_position()
	var distance = slime_position.distance_to(target_position)
			
	if distance <= TARGET_DISTANCE: target = node
	
func damage(amount):
	if HEALTH <= 0: return
	
	HEALTH -= amount
	$AudioStreamPlayer.pitch_scale = rand_range(0.8, 1.2)
	$AudioStreamPlayer.play()
	$AnimatedSprite.play("hurt")
	
	if HEALTH <= 0:
		disabled = true
		$AnimatedSprite.play("death")
		var item = ITEM.instance()
		Game.get_map().add_child(item)
		item.transform.origin = transform.origin
		yield($AnimatedSprite, "animation_finished")
		queue_free()

func _on_Area2D_body_entered(body):
	if body.is_in_group("resource") and $AnimatedSprite.animation == "spawn":
		queue_free()
	if body.is_in_group("player"):
		charging = false
		attacking = false
		target = null
		target_lock = Vector2.ZERO
		body.damage(ATTACK_STRENGTH, transform.origin.direction_to(Game.get_player().transform.origin))
