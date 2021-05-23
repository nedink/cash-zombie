extends Timer




func _on_LifeTimer_timeout():
	if get_parent().has_method("destroy"):
		get_parent().destroy()
		return
	get_parent().queue_free()
