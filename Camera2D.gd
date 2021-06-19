extends Camera2D


export var max_offset = Vector2(100, 75)  # Maximum hor/ver shake in pixels.

export var max_roll = 0.1  # Maximum rotation in radians (use sparingly).

onready var chrome_vig: ColorRect = $"/root/World/UI/ChromeVig"


func on_shake(amount):
	rotation = max_roll * amount * rand_range(-1, 1)
	var pos = Vector2(
		max_offset.x * amount * rand_range(-1, 1),
		max_offset.y * amount * rand_range(-1, 1)
	)
	offset = pos
	
	var sh : ShaderMaterial = chrome_vig.material
#	sh.set_shader_param("light", min(pos.length() * 0.1, 0.7))
#	sh.set_shader_param("extend", 0.5 + offset.length() * 0.1)
	sh.set_shader_param("offset", pos * 2)
