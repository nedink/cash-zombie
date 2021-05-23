extends Node2D


# handles charge and release animation, and scaling




func _ready():
	hide()
#	$AnimationPlayer.assi = "char"
	




#func start(speed = 1.0):
#	$Sprite.show()
#	$AnimationPlayer.assigned_animation = "charging"
#	$AnimationPlayer.play("charging", -1, speed)
#	$AnimationPlayer.seek(0)


func charging(charge_value: float):
	show()
	$AnimationPlayer.play("charging")
	var anim_len = $AnimationPlayer.current_animation_length
	$AnimationPlayer.seek(charge_value / anim_len)


func max_charge():
	$AnimationPlayer.play("max_charge")


func release():
	# TODO - implement release animation
	hide()
	$AnimationPlayer.stop()
	pass


func cancel():
	# TODO - implement cancel animation
	hide()
	$AnimationPlayer.stop()
	pass
