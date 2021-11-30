extends Node2D


onready var player = get_tree().get_nodes_in_group("player")[0]



#func _ready():
#	$UI/Energy.value = 100



func _ready():
	
	Events.connect("pause", self, "on_pause")
	
	for x in range(-4, 4):
		for y in range(-4, 4):
			$TileMap.set_cell(x, y, rand_range(0, 16))
#	slow_mo()
#	Engine.time_scale = .5
	


func _input(event):
	if event.is_action("ui_cancel"):
		get_tree().quit()
	if event.is_action_pressed("secondary_cast"):
		Events.emit_signal("pause")
		
	if event.is_action_pressed("scroll_up"):
		Engine.time_scale += 0.1
	if event.is_action_pressed("scroll_down"):
		Engine.time_scale -= 0.1

	



func _process(delta):
	$UI/Fps.text = str(Engine.get_frames_per_second())
	$UI/Nodes.text = str(get_tree().get_node_count())
	$UI/MousePosition.text = str(get_global_mouse_position())
	var zeds = 0
	for c in $YSort.get_children():
		if c.is_in_group("enemy"):
			zeds += 1
	$UI/Enemies.text = "Enemies " + str(zeds)





func slow_mo(time: float, in_time: float, out_time: float):
	$TimeScaleTween.interpolate_property(Engine, "time_scale", 0.5, 1.0, 2, Tween.TRANS_CUBIC, Tween.EASE_IN)
	$TimeScaleTween.start()
	yield($TimeScaleTween, "")
	
	



func on_pause():
	get_tree().paused = !get_tree().paused
