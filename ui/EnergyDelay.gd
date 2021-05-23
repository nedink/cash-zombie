extends TextureProgress


#onready var energu = $"/root/World/Player".energy


onready var player = $"/root/World/Player"



#func _ready():
#	value = player.energy_max

#var values = []

export var follow_speed = 25.0


func _process(delta:float):
	pass
#	[]
	if $DelayTimer.is_stopped():
		if $"../EnergyPreCharge".values:
			var v = $"../EnergyPreCharge".values.pop_front()
			value = value - follow_speed * delta if v < value else v
	
	
	
#	if value > $"../EnergyPreCharge".value:
##		print("true")
##		value -= 8 * delta
#		if $DelayTimer.is_stopped():
#			$DelayTimer.start()
#
#
#		if not $Tween.is_active(): 
#			$Tween.follow_property(self, "value", value, $"../EnergyPreCharge", "value", 1, Tween.TRANS_LINEAR, Tween.EASE_IN, 0.5)
#			$Tween.start()
##		$Tween.start()
##		if not $Tween.is_active():
##			$Tween.start()
#		return
#	value = $"../EnergyPreCharge".value

#		print(value)
#	else:
#		pass
#		print("false")
#		value -= 10 * delta
#		return
#	print($"../EnergyPreCharge".value)
#	value -= 10 * delta
#	print(value)
#	update()
#	value = $"../EnergyPreCharge".value
#	value = max()
#	$Tween.interpolate_property(self, "value", value, $"../EnergyPreCharge".value, 1, Tween.TRANS_LINEAR)
#	value = 
##	value = 
#	pass



#func _on_DropTimer_timeout():
