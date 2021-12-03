extends Area2D

func hit(body, point):
	get_parent().hit(body, point)
