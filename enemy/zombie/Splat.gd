extends Node2D


func _ready():
	for c in get_children():
		if "emitting" in c:
			c.emitting = true
	
	var lifetime = 0
	for c in get_children():
		if c is Particles2D and c.lifetime > lifetime:
			lifetime = c.lifetime
	$ParticlesTimer.start(lifetime)
	$LifeTimer.start(lifetime)


func _on_ParticlesTimer_timeout():
	queue_free()
