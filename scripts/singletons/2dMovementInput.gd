extends Node

var last = Vector2.ZERO

func start(movement, node: KinematicBody2D, player: int):
	var input = Vector2.ZERO
	var playerString = 'player' + str(player) + '_'
	
	if Input.is_action_pressed(playerString + 'up'):
		input.y -= 1
	if Input.is_action_pressed(playerString + 'down'):
		input.y += 1
	if Input.is_action_pressed(playerString + 'left'):
		input.x -= 1
	if Input.is_action_pressed(playerString + 'right'):
		input.x += 1

	if input != Vector2.ZERO: last = input

	movement.move(node, input)
