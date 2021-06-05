extends Node2D


export var enabled = true

var zombie_scene = preload("res://enemy/zombie/Zombie.tscn")



func _on_Timer_timeout():
	if not enabled:
		return
	var zomb = zombie_scene.instance()
	$"/root/World/YSort".add_child(zomb)
	zomb.global_position = global_position
	


#func set_enabled(val:bool):
#	enabled = val
#	if enabled:
#		$Timer.call_deferred("start")
#	else:
#		$Timer.call_deferred("stop")
#		$Timer.stop()

#func get_enabled():
#	return enabled
