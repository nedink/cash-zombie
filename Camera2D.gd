extends Camera2D

export var decay = 0.8  # How quickly the shaking stops [0, 1].

export var max_offset = Vector2(100, 75)  # Maximum hor/ver shake in pixels.

export var max_roll = 0.1  # Maximum rotation in radians (use sparingly).

export (NodePath) var target  # Assign the node this camera will follow.


var trauma = 0  # Current shake strength.

var trauma_power = 2  # Trauma exponent. Use [2, 3].

onready var chrome_vig: ColorRect = $"/root/World/UI/ChromeVig"



func _ready():
	randomize()

func add_trauma(amount: float) -> void:
	trauma = min(trauma + amount, 1.0)

func raise_trauma(amount: float) -> void:
	trauma = amount if trauma < amount else trauma


func _process(delta):
	if target:
		global_position = get_node(target).global_position
#	if trauma:
	trauma = max(trauma - decay * delta, 0)
	shake()


func shake():
	var amount = pow(trauma, trauma_power)
	rotation = max_roll * amount * rand_range(-1, 1)
	var pos = Vector2(
		max_offset.x * amount * rand_range(-1, 1),
		max_offset.y * amount * rand_range(-1, 1)
	)
	offset = pos
	
	var sh : ShaderMaterial = chrome_vig.material
	sh.set_shader_param("light", min(pos.length() * 0.1, 0.8))
#	sh.set_shader_param("extend", 0.5 + offset.length() * 0.1)
	sh.set_shader_param("offset", pos.length() * 2)
	
	
#	Engine.time_scale = clamp((1 / pos.length() * $SloMo.coefficients) if $SloMo.coefficient > 0 else 1, 0, 1)
#	Engine.time_scale = time_scale
#	if pos.length() > 0:
	
#	Engine.time_scale = clamp(1 / pos.length() * 2 if pos.length() > 0 else 1, 0, 1)
