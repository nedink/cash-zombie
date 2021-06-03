extends Node2D


func _ready():
	$Particles2D.emitting = true
	$Particles2D2.emitting = true
#	$ParticlesTimer.wait_time = 
	$ParticlesTimer.start($Particles2D.lifetime)


func _on_ParticlesTimer_timeout():
	queue_free()
