extends Node2D

export var SPEED = 100

var _speed_multiplier = 1.0
var _velocity = Vector2.ZERO
var _direction = "down"
var _moving = false

var Direction = {
	"up": Vector2(0, -1),
	"down": Vector2(0, 1),
	"left": Vector2(-1, 0),
	"right": Vector2(1, 0),
	"up left": Vector2(-1, -1),
	"up right": Vector2(1, -1),
	"down left": Vector2(-1, 1),
	"down right": Vector2(1, 1)
}

func get_speed_multiplier():
	return _speed_multiplier

func get_velocity():
	return _velocity

func get_direction(direction = null):
	if direction == null:
		return _direction
	else:
		return Direction.keys()[Direction.values().find(direction)].split(" ")[0]

func get_vector(direction):
	return Direction.values()[Direction.keys().find(direction)]

func is_moving():
	return _moving

func set_speed_multiplier(value):
	_speed_multiplier = value

func set_velocity(value):
	_velocity = value

func set_direction(value):
	_direction = value

func move(body: KinematicBody2D, input, multiplier = 1.0):
	if input is String: input = get_vector(input)

	_velocity = input.normalized()
	_direction = get_direction(input) if input != Vector2.ZERO else _direction
	_moving = input != Vector2.ZERO

	return body.move_and_slide((_velocity * SPEED) * multiplier, Vector2.UP)
