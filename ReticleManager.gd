extends Node2D



func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)


func _process(delta):
	if reticle():
		reticle().global_position = get_global_mouse_position()


func reticle():
	return get_child(0)


func set_reticle(reticle_node: Node2D):
	for c in get_children():
		remove_child(c)
		c.queue_free()
	add_child(reticle_node)
