extends Node2D

signal done_talking()

var INTERFACE = preload("res://scenes/Interface.tscn")
onready var LEVELS = {
	"Overworld": preload("res://levels/Overworld.tscn").instance(),
	"Underworld": preload("res://levels/Underworld_REDO.tscn").instance()
}
var TEXT = [
	[
		"We can't keep running from them for his benefit.",
		"ALL HE HAS TO DO-",
		"...All he has to do is take off his hat. It's been outlawed since their rule. You know this.\n",
		"We've got no other choice. I'll build him a fire, maybe it'll give him a chance, alright?\n\n\nHe can HIT the fire with the ACTION BUTTON to CRAFT too.\n"
	],
	[
		"There's nothing we can do! What's he going to do out here? It's unforgiving, there's limited resources, he has nothing to defend himself.\n",
		"SHHH! Be quiet, he's sleeping in the back!",
		"...Let's build him a fire then."
	]
]
var TEXT_DONE = false
var INTRO_DONE = false
var SKIP = false
var SWITCHING = false

func _ready():
	Game.LOADING_MAP = false
	Game.LOADING_RESOURCES = false
	Game.LOADING = false
	
	$Intro/AudioStreamPlayer3/AnimationPlayer.play("default")
	$Intro/AudioStreamPlayer3.play(18)
	$CanvasLayer/dark/AnimationPlayer.play("default")
	$player_1.disabled = true
	
func _process(delta):
	if not TEXT_DONE and not INTRO_DONE and Input.is_action_just_pressed("use"):
		if SKIP:
			skip()
			$CanvasLayer/Skip.visible = false
		else:
			SKIP = true
			$CanvasLayer/Skip.visible = true
		
func level(to):
	if SWITCHING: return
	SWITCHING = true
	var level = to
	var interface = Game.get_interface()
	yield(get_tree().create_timer(0.25), "timeout")
	for child in $Map.get_children():
		$Map.remove_child(child)
	$Map.add_child(level)
	yield(get_tree().create_timer(1.0), "timeout")
	SWITCHING = false

func scroll_text(box, text, number, pitch_scale = Vector2(0.1, 0.2), timeout = 4):
	box.text = text
	box.visible_characters = 0
	for i in range(len(text)):
		if TEXT_DONE: break
		if i % 2 == 0:
			get_node("Intro/AudioStreamPlayer" + str(number)).stop()
			get_node("Intro/AudioStreamPlayer" + str(number)).pitch_scale = rand_range(pitch_scale.x, pitch_scale.y)
			get_node("Intro/AudioStreamPlayer" + str(number)).play(0.0)
		box.visible_characters += 1
		yield(get_tree().create_timer(0.05), "timeout")
	yield(get_tree().create_timer(timeout), "timeout")
	emit_signal("done_talking")
	
func finish():
	INTRO_DONE = true
	level(LEVELS["Overworld"])
	add_child(INTERFACE.instance())
	$CanvasLayer/dark/AnimationPlayer.play("default")
	$Intro/AudioStreamPlayer3/AnimationPlayer.play_backwards("default")
	$player_1.disabled = false
	yield($Intro/AudioStreamPlayer3/AnimationPlayer, "animation_finished")
	remove_child($Intro)
	
func skip():
	if TEXT_DONE: return
	$Intro/Label1.visible = false
	$Intro/Label2.visible = false
	$CanvasLayer/dark/AnimationPlayer.play_backwards("default")
	$player_1.visible = true
	TEXT_DONE = true
	
func _on_AnimationPlayer_animation_finished(anim_name):
	if TEXT_DONE and not INTRO_DONE: finish()
	if TEXT_DONE: return
	$Intro/Label1.visible = true
	$Intro/Label2.visible = false
	scroll_text($Intro/Label1, TEXT[0][0], 1)
	yield(self, "done_talking")
	if TEXT_DONE: 
		skip()
		return
	$Intro/Label1.visible = false
	$Intro/Label2.visible = true
	scroll_text($Intro/Label2, TEXT[1][0], 2, Vector2(0.3, 0.4))
	yield(self, "done_talking")
	if TEXT_DONE: 
		skip()
		return
	$Intro/Label1.visible = true
	$Intro/Label2.visible = false
	scroll_text($Intro/Label1, TEXT[0][1], 1, Vector2(0.1, 0.2), 1)
	yield(self, "done_talking")
	if TEXT_DONE: 
		skip()
		return
	$Intro/Label1.visible = false
	$Intro/Label2.visible = true
	scroll_text($Intro/Label2, TEXT[1][1], 2, Vector2(0.3, 0.4))
	yield(self, "done_talking")
	if TEXT_DONE: 
		skip()
		return
	$Intro/Label1.visible = true
	$Intro/Label2.visible = false
	scroll_text($Intro/Label1, TEXT[0][2], 1)
	yield(self, "done_talking")
	if TEXT_DONE: 
		skip()
		return
	$Intro/Label1.visible = true
	$Intro/Label2.visible = false
	scroll_text($Intro/Label1, TEXT[0][3], 1)
	yield(self, "done_talking")
	if TEXT_DONE: 
		skip()
		return
	$Intro/Label1.visible = false
	$Intro/Label2.visible = true
	scroll_text($Intro/Label2, TEXT[1][2], 2, Vector2(0.3, 0.4))
	yield(self, "done_talking")
	$Intro/Label1.visible = false
	$Intro/Label2.visible = false
	$CanvasLayer/dark/AnimationPlayer.play_backwards("default")
	$player_1.visible = true
	TEXT_DONE = true
