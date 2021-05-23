extends Node2D


class_name ParticleCaster



# caster modifiers
export var cast_delay = 0.5
export var spread_degrees = 10


# cast modifiers
#export var initial_velocity = 800
#export var damping = 0.025
#export var damage = 1
#export var life_time = 1.0


export (Dictionary) var payload = {
	"impact_force": 10,
	"initial_velocity": 800,
	"damping": 0.025,
	"damage": 10,
	"life_time": 1.0,
	"knockback": 1.0,
}

var cast_scene:PackedScene = load("res://cast/orb/OrbProjectile.tscn")


func _ready():
	pass


#func try_cast():
#	if $CastTimer.is_stopped():
#		var cast = cast_scene.instance()
#		cast.caster = self
#		cast.payload = payload
#		$"/root/World".add_child(cast)
#		cast.rotation += deg2rad(rand_range(-spread_degrees/2, spread_degrees/2))
#		$CastTimer.start(cast_delay)
#	else:
#		pass
