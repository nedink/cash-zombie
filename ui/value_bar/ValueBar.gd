extends Control

enum FillMode {
	FILL_LEFT_TO_RIGHT,
	FILL_RIGHT_TO_LEFT,
	FILL_TOP_TO_BOTTOM,
	FILL_BOTTOM_TO_TOP,
	FILL_CLOCKWISE,
	FILL_COUNTER_CLOCKWISE,
	FILL_BILINEAR_LEFT_AND_RIGHT,
	FILL_BILINEAR_TOP_AND_BOTTOM,
	FILL_CLOCKWISE_AND_COUNTER_CLOCKWISE,
}

export var node_path: NodePath
export var max_member: String
export var value_member: String
export var follow_speed = 25.0
export (FillMode) var fill_mode = 0

onready var node = get_node(node_path)





func _ready():
	for c in get_children():
		c.fill_mode = fill_mode



func get_max():
	return node.call(max_member) if node.has_method(max_member) else node.get(max_member)
	
	
func get_value():
	return node.call(value_member) if node.has_method(value_member) else node.get(value_member)
	
