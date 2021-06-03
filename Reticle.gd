extends Node2D


#onready var player = $"/root/World/YSort/Player"


#func _ready():
#	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	
	
	
#func _process(delta):
#	global_position = get_global_mouse_position()
#	look_at(player.global_position)

#func _draw():



func set_state(state: int, seek = -1):
#	Cast.State.properties
#	Cast.State.
#	print(state.)
#	if seek < 0:
#		$AnimationPlayer.play()
	$AnimationPlayer.play(str(Cast.State.keys()[state]))
	if seek >= 0:
		$AnimationPlayer.seek(seek)
#		$AnimationPlayer.stop(false)
#	print(state)
#	if state == Cast.State.IDLE:


