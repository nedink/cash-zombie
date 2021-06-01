extends Control


export var node_path: NodePath
export var max_property: String
export var value_property: String
export var follow_speed = 25.0

onready var node = get_node(node_path)
