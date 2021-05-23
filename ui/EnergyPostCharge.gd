extends TextureProgress



onready var player = $"/root/World/Player"



func _ready():
	value = player.energy_max



func _process(delta):
	min_value = 0
	max_value = player.energy_max
	value = player.energy_value - player.charge_value * player.primary_cast().energy_drain
