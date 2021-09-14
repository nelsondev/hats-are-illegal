extends CanvasLayer

var index = 0

func _ready():
	$AnimationPlayer_Hearts.play("bop")

func _process(delta):
#	$Loading.visible = Game.LOADING
	$Resources/slime/Label.text = str(Game.RESOURCES["slime"])
	$Resources/wood/Label.text = str(Game.RESOURCES["wood"])
	$Resources/stone/Label.text = str(Game.RESOURCES["stone"])
	$Resources/iron/Label.text = str(Game.RESOURCES["iron"])
	
	if Input.is_action_just_pressed("item_left"):
		index = index - 1 if index > 0 else 7
	if Input.is_action_just_pressed("item_right"):
		index = index + 1 if index < 7 else 0
	if Input.is_action_just_pressed("item_left") \
		or Input.is_action_just_pressed("item_right"):
			if Game.INVENTORY.size() >= index + 1:
				Game.get_player().get_node("Tool").set_tool(Game.INVENTORY[index].instance())
			else:
				Game.get_player().get_node("Tool").set_tool(null)
	
	for i in range(Game.INVENTORY.size()):
		var item_sprite = $Items.get_node("item" + str(i))
	
		if item_sprite.texture != null: continue
	
		var item = Game.INVENTORY[i].instance()
		var texture = item.get_node("PlayerAnimated").texture
		
		item_sprite.texture = texture
	
	var node = $Boxes.get_node("itembox" + str(index))
	
	$Boxes/itembox_selected.transform.origin = node.transform.origin

	if Game.HEALTH == 3: 
		$Heart1.frame = 0
		$Heart2.frame = 0
		$Heart3.frame = 0
	if Game.HEALTH == 2.5: 
		$Heart1.frame = 0
		$Heart2.frame = 0
		$Heart3.frame = 1
	if Game.HEALTH == 2: 
		$Heart1.frame = 0
		$Heart2.frame = 0
		$Heart3.frame = 2
	if Game.HEALTH == 1.5: 
		$Heart1.frame = 0
		$Heart2.frame = 1
		$Heart3.frame = 2
	if Game.HEALTH == 1: 
		$Heart1.frame = 0
		$Heart2.frame = 2
		$Heart3.frame = 2
	if Game.HEALTH == 0.5: 
		$Heart1.frame = 1
		$Heart2.frame = 2
		$Heart3.frame = 2
	if Game.HEALTH == 0:
		$Heart1.frame = 2
		$Heart2.frame = 2
		$Heart3.frame = 2

func open_crafting():
	$AudioStreamPlayer_Open.play()
	$AudioStreamPlayer_Open2.play()
	$AudioStreamPlayer_Open3.play()
	Game.get_player().disabled = true
	$Menu_Crafting.visible = true
	$Menu_Prices.visible = true
	
func close_crafting():
	Game.get_player().disabled = false
	$Menu_Crafting.visible = false
	$Menu_Prices.visible = false
