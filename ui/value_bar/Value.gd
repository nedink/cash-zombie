extends TextureProgress


#var values = []



func _process(delta):
	min_value = 0
	max_value = get_parent().get_max()
	value = get_parent().get_value()
#	values.append(value)
