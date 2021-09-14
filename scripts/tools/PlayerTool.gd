extends Node

var _stats = null

func get_tool():
	return _stats

func get_tool_animation():
	if _stats == null: return null
	return _stats.get_node("AnimationPlayer")

func set_tool(tool_node: Node2D):
	if tool_node == null:
		for child in get_children():
			child.queue_free()
		_stats = null
	else:
		var stats = tool_node.get_node("PlayerAnimated")
		if stats == null: return
		for child in get_children():
			child.queue_free()
		_stats = stats
		add_child(tool_node)

func get_enemy_damage():
	if _stats == null: return 0.1
	return _stats.ENEMY_DAMAGE
	
func get_resource_damage(resource):
	if _stats == null: return 0.1
	if resource.RESOURCE_NAME in _stats.RESOURCE_PREFERRED:
		return _stats.RESOURCE_DAMAGE
	else:
		return 0.1
