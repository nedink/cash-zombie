extends Node2D



func _process(delta):
	var mouse_pos = get_parent().get_local_mouse_position()
	position = mouse_pos * 0.2


