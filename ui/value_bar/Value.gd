extends TextureProgress


var values = []



func _process(delta):
	min_value = 0
	max_value = get_parent().node.get(get_parent().max_property)
	value = get_parent().node.get(get_parent().value_property)
	values.append(value)
