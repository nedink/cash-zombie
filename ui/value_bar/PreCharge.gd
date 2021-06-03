extends TextureProgress




var values = []

onready var player = $"/root/World/YSort/Player"



func _ready():
	value = player.energy_max


func _process(delta):
	min_value = 0
	max_value = player.energy_max
	value = player.energy_value
	values.append(value)
