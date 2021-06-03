extends Timer

export var node: NodePath
export var prop: String
export var in_time = 0.5
export var out_time = 0.5

onready var target = get_node(node)

var is_in = false


func _ready():
	target.scale = Vector2.ZERO


func unhide():
	if not is_in:
		$Tween.interpolate_property(target, prop, Vector2.ZERO, Vector2.ONE, in_time, Tween.TRANS_EXPO, Tween.EASE_OUT)
		$Tween.start()
	start()
	is_in = true


func _on_HideTimer_timeout():
	$Tween.interpolate_property(target, prop, Vector2.ONE, Vector2.ZERO, out_time, Tween.TRANS_EXPO, Tween.EASE_IN)
	$Tween.start()
	is_in = false

