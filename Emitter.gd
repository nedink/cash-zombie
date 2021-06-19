extends Node2D


class_name Emitter


export (PackedScene) var emission_scene
export var amount = 1
export var initial_velocity = 0.0
export var direction = Vector2.RIGHT
export var spread = 0.0


onready var emission = emission_scene.instance()


func _ready():
	for i in amount:
		var e = emission.duplicate()
		$"/root/World".add_child(e)
