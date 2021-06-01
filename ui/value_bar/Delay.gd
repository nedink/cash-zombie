extends TextureProgress


func _process(delta:float):
	min_value = 0
	max_value = get_parent().node[get_parent().max_property]
	
	if value < get_parent().node[get_parent().value_property]:
		value = get_parent().node[get_parent().value_property]
		$DelayTimer.start()
	
	if $DelayTimer.is_stopped() and get_parent().get_child(get_parent().get_child_count() - 1).value < value:
		value -= get_parent().follow_speed * delta
	
