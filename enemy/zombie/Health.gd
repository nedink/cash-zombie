extends Position2D


func _process(delta):
	$Health.max_value = $"../../".health_max
	$Health.value = $"../../".health_value
	$Label.text = str($"../../".health_value)
