extends Node2D



#func _ready():
#	$UI/Energy.value = 100



func _ready():
	for x in range(-8, 8):
		for y in range(-8, 8):
#			if Vector2(x, y).length() <= 6:
#				$TileMap.set_cell(x, y, rand_range(0, 16))
			$TileMap.set_cell(x, y, rand_range(0, 16))


func _input(event):
	if event.is_action("ui_cancel"):
		get_tree().quit()
	if event.is_action_pressed("ui_accept"):
		get_tree().paused = !get_tree().paused
	



func _process(delta):
	
	$UI/Fps.text = str(Engine.get_frames_per_second())
	$UI/Nodes.text = str(get_tree().get_node_count())
	$UI/MousePosition.text = str(get_global_mouse_position())
