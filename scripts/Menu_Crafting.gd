extends Control

var index = 0
var has_axe = false
var has_pickaxe = false
var has_sword = false
var has_shield = false

func _process(delta):
	if not visible: return
	
	var node = get_node("Button_" + str(index))
	var prices = $"../Menu_Prices/Prices"
	var wood = prices.get_node("wood/Label")
	var slime = prices.get_node("slime/Label")
	var stone = prices.get_node("stone/Label")
	var iron = prices.get_node("iron/Label")
	$cursor.transform.origin = node.transform.origin
	
	if index == 1:
		wood.text = "000"
		slime.text = "000"
		stone.text = "000"
		iron.text = "000"
	elif index == 2:
		wood.text = "500"
		slime.text = "25*"
		stone.text = "000"
		iron.text = "000"
	elif index == 3:
		if node.animation == "disabled":
			wood.text = "???"
			slime.text = "???"
			stone.text = "???"
			iron.text = "???"
		else:
			wood.text = "500"
			slime.text = "25*"
			stone.text = "150"
			iron.text = "3**"
	elif index == 4:
		if node.animation == "disabled":
			wood.text = "???"
			slime.text = "???"
			stone.text = "???"
			iron.text = "???"
		else:
			wood.text = "500"
			slime.text = "25*"
			stone.text = "100"
			iron.text = "50*"
	else:
		wood.text = "???"
		slime.text = "???"
		stone.text = "???"
		iron.text = "???"
		
	if Input.is_action_just_pressed("player1_up"):
		index = index - 1 if index > 0 else 4
		$"../AudioStreamPlayer_Open2".play()
		$"../AudioStreamPlayer_Open3".play()
	if Input.is_action_just_pressed("player1_down"):
		index = index + 1 if index < 4 else 0
		$"../AudioStreamPlayer_Open2".play()
		$"../AudioStreamPlayer_Open3".play()
	if Input.is_action_just_pressed('use'):
		$"../AudioStreamPlayer_Open2".play()
		$"../AudioStreamPlayer_Click".play()
		if node.animation != "default": 
			Game.get_camera().shake(5, 0.1)
			return	
		if index == 0:
			node.play("clicked")
			yield(get_tree().create_timer(0.1), "timeout")
			Game.get_interface().close_crafting()
			node.play("default")
		elif index == 1:
			if has_axe:
				Game.get_camera().shake(5.0, 0.1)
				return
			has_axe = true
			node.play("clicked")
			for child in node.get_children():
				child.transform.origin.y += 1
			$"../AudioStreamPlayer_Click2".pitch_scale = rand_range(0.85, 0.95)
			$"../AudioStreamPlayer_Click2".play()
			$"../AudioStreamPlayer_Open2".play()
			Game.get_camera().shake(1.0, 0.2)
			yield(get_tree().create_timer(0.3), "timeout")
			$"../AudioStreamPlayer_Click2".pitch_scale = rand_range(0.85, 0.95)
			$"../AudioStreamPlayer_Click2".play()
			$"../AudioStreamPlayer_Open2".play()
			Game.get_camera().shake(1.0, 0.2)
			yield(get_tree().create_timer(0.3), "timeout")
			$"../AudioStreamPlayer_Click2".pitch_scale = rand_range(0.85, 0.95)
			$"../AudioStreamPlayer_Click2".play()
			$"../AudioStreamPlayer_Open2".play()
			Game.get_camera().shake(1.0, 0.2)
			yield(get_tree().create_timer(0.3), "timeout")
			Game.get_interface().close_crafting()
			var axe = load("res://scenes/tools/Axe.tscn").instance()
			Game.get_map().add_child(axe)
			axe.transform.origin = Game.get_map().get_node("Camp").transform.origin
			$"../AudioStreamPlayer_Pop".play()
		elif index == 2:
			if has_pickaxe:
				Game.get_camera().shake(5.0, 0.1)
				return
			if Game.RESOURCES["wood"] < 500 or Game.RESOURCES["slime"] < 25:
				Game.get_camera().shake(5.0, 0.1)
				return
			Game.RESOURCES["wood"] -= 500
			Game.RESOURCES["slime"] -= 25
			$Button_3.play("default")
			$Button_3/axe.visible = true
			$Button_3/axe2.visible = true
			has_pickaxe = true
			node.play("clicked")
			
			for child in node.get_children():
				child.transform.origin.y += 1
			$"../AudioStreamPlayer_Click2".pitch_scale = rand_range(0.85, 0.95)
			$"../AudioStreamPlayer_Click2".play()
			$"../AudioStreamPlayer_Open2".play()
			Game.get_camera().shake(1.0, 0.2)
			yield(get_tree().create_timer(0.3), "timeout")
			$"../AudioStreamPlayer_Click2".pitch_scale = rand_range(0.85, 0.95)
			$"../AudioStreamPlayer_Click2".play()
			$"../AudioStreamPlayer_Open2".play()
			Game.get_camera().shake(1.0, 0.2)
			yield(get_tree().create_timer(0.3), "timeout")
			$"../AudioStreamPlayer_Click2".pitch_scale = rand_range(0.85, 0.95)
			$"../AudioStreamPlayer_Click2".play()
			$"../AudioStreamPlayer_Open2".play()
			Game.get_camera().shake(1.0, 0.2)
			yield(get_tree().create_timer(0.3), "timeout")
			Game.get_interface().close_crafting()
			var axe = load("res://scenes/tools/Pickaxe.tscn").instance()
			Game.get_map().add_child(axe)
			axe.transform.origin = Game.get_map().get_node("Camp").transform.origin
			$"../AudioStreamPlayer_Pop".play()
		elif index == 3:
			if has_sword:
				Game.get_camera().shake(5.0, 0.1)
				return
			if Game.RESOURCES["wood"] < 500 \
				or Game.RESOURCES["slime"] < 25 \
				or Game.RESOURCES["stone"] < 150 \
				or Game.RESOURCES["iron"] < 150:
				Game.get_camera().shake(5.0, 0.1)
				return
			Game.RESOURCES["wood"] -= 500
			Game.RESOURCES["slime"] -= 25
			Game.RESOURCES["stone"] -= 150
			Game.RESOURCES["iron"] -= 3
			$Button_4.play("default")
			$Button_4/axe.visible = true
			$Button_4/axe2.visible = true
			has_sword = true
			node.play("clicked")
			for child in node.get_children():
				child.transform.origin.y += 1
			$"../AudioStreamPlayer_Click2".pitch_scale = rand_range(0.85, 0.95)
			$"../AudioStreamPlayer_Click2".play()
			$"../AudioStreamPlayer_Open2".play()
			Game.get_camera().shake(1.0, 0.2)
			yield(get_tree().create_timer(0.3), "timeout")
			$"../AudioStreamPlayer_Click2".pitch_scale = rand_range(0.85, 0.95)
			$"../AudioStreamPlayer_Click2".play()
			$"../AudioStreamPlayer_Open2".play()
			Game.get_camera().shake(1.0, 0.2)
			yield(get_tree().create_timer(0.3), "timeout")
			$"../AudioStreamPlayer_Click2".pitch_scale = rand_range(0.85, 0.95)
			$"../AudioStreamPlayer_Click2".play()
			$"../AudioStreamPlayer_Open2".play()
			Game.get_camera().shake(1.0, 0.2)
			yield(get_tree().create_timer(0.3), "timeout")
			Game.get_interface().close_crafting()
			var axe = load("res://scenes/tools/Sword.tscn").instance()
			Game.get_map().add_child(axe)
			axe.transform.origin = Game.get_map().get_node("Camp").transform.origin
			$"../AudioStreamPlayer_Pop".play()
		elif index == 4:
			pass

