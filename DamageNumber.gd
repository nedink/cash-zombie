extends Node2D


var value: int


func _ready():
	$Label.text = str(value) 
	$Label/Tween.interpolate_property(self, "position", position, position + Vector2(rand_range(-16, 16), -48), 2, Tween.TRANS_EXPO, Tween.EASE_OUT)
	$Label/Tween.interpolate_property(self, "scale", scale, Vector2.ONE * max(1, log(value * 0.1)), 0.5, Tween.TRANS_EXPO, Tween.EASE_OUT)
	$Label/Tween.start()
