extends Node2D


func _ready():
#	if get_tree().get_node_count() > 200:
#		queue_free()
	$AnimationPlayer.play("explode")
#	$Explosion.emitting = true
#	$Explosion.one_shot = true
#	$LifeTimer.wait_time = lifetime

func _on_LifeTimer_timeout():
#	queue_free()
	pass


func _on_AnimationPlayer_animation_finished(anim_name):
	queue_free()
