extends Node

class_name Trauma


export var decay = 0.8  # How quickly the shaking stops [0, 1].


var trauma = 0  # Current shake strength.

var trauma_power = 2  # Trauma exponent. Use [2, 3].


signal on_shake(amount)


func _ready():
	connect("on_shake", get_parent(), "on_shake")
	randomize()

func add_trauma(amount: float) -> void:
	trauma = min(trauma + amount, 1.0)

func raise_trauma(amount: float) -> void:
	trauma = amount if trauma < amount else trauma


func _process(delta):
	trauma = max(trauma - decay * delta, 0)
	shake()


func shake():
	var amount = pow(trauma, trauma_power)
	emit_signal("on_shake", amount)
	
	
