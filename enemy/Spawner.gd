extends Node2D

class_name Spawner


export var enabled = true
export (PackedScene) var spawn_scene



func _on_Timer_timeout():
	if not enabled:
		return
	var spawn = spawn_scene.instance()
	$"/root/World/YSort".add_child(spawn)
	spawn.global_position = global_position
	
