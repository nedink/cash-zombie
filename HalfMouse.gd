extends Node2D



func _process(delta):
	var mouse_pos = get_parent().get_local_mouse_position()
	position = mouse_pos * Vector2(0.25, 0.45)


