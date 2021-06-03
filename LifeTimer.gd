extends Timer




func _on_LifeTimer_timeout():
#	print(wait_time)
	if get_parent().has_method("destroy"):
		get_parent().destroy()
		return
	get_parent().queue_free()
