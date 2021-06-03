extends TextureProgress


func _process(delta:float):
	min_value = 0
	max_value = get_parent().get_max()
	
	if value < get_parent().get_value():
		value = get_parent().get_value()
		$DelayTimer.start()
		
	
	if $DelayTimer.is_stopped() and get_parent().get_child(get_parent().get_child_count() - 1).value < value:
		value -= get_parent().follow_speed * delta
	
