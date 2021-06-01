extends Timer


func _ready():
	pass


func unhide():
	get_parent().show()
	start()


func _on_HideTimer_timeout():
	get_parent().hide()
