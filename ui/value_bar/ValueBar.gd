extends Control


export var node_path: NodePath
export var max_member: String
export var value_member: String
export var follow_speed = 25.0

onready var node = get_node(node_path)

func get_max():
	return node.call(max_member) if node.has_method(max_member) else node.get(max_member)
	
	
func get_value():
	return node.call(value_member) if node.has_method(value_member) else node.get(value_member)
	
