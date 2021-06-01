extends Node

class_name Utils



static func sum(list: Array):
	var s = 0.0
	if list:
		if list[0] is Vector2:
			s = Vector2()
	for i in list:
		s += i
	return s


static func avg(list: Array):
	return sum(list) / (len(list) if list else 0)



