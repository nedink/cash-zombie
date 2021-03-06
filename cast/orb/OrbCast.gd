extends Cast


class_name OrbCast




export var cast_name = "orb"

export var cast_cooldown = 0.25
export var spread_degrees = 10
export var automatic = true



export var energy_drain = 2

#export var charge_required = 1.0
#export var charge_min = 1.0
#export var charge_max = 1.0
export var chargeable = true
export var charge_speed = 5.0
#export var charge_initial = 0.0

#export var charge_damage = 2
#export var charge_velocity = 2


# payload
export var velocity = 800
export var damping = 2.0
export var damage = 4
export var size = 1.0
#export var impact_force= 10
export var life_time = 1.0
export var mass = 0.0
export var knockback = 0.0


var charge_value = 0



export var projectile_scene:PackedScene

# Caster/Slots/Primary/@
onready var caster = get_parent().get_parent().get_parent()

var reticle_scene = load("res://cast/" + cast_name + "/Reticle.tscn")
onready var reticle_manager = $"/root/World/ReticleManager"
var reticle

func _ready():
	reticle = reticle_scene.instance()
	reticle_manager.set_reticle(reticle)


#func _ready():
#	payload = payload.duplicate()


func pos_step():
	return caster.pos_step










func cast(charge_value: float):
	var projectile = projectile_scene.instance()
#	projectile.caster = self
#	projectile.payload = payload
	projectile.life_time = life_time
	$"/root/World".add_child(projectile)
	projectile.global_transform = caster.get_node("Body/CastPoint").global_transform
	# give additional velocity in the direction of movement
	var vel_len = max(((Vector2.RIGHT.rotated(projectile.global_rotation) * velocity) + pos_step()).length(), velocity)
	projectile.vel = Vector2.RIGHT * vel_len
	projectile.damping = damping
	projectile.damage =  damage
	projectile.size = size
	projectile.mass = mass
	projectile.knockback = knockback
	
#	var dmg = [1, 10, 100, 1000, 10000] 
#	projectile.damage = dmg[rand_range(0, 5)]
	
	# charge effects
#	projectile.scale = Vector2.ONE * max(1, charge_value)
	
	# spread
	projectile.rotation += deg2rad(rand_range(-spread_degrees/2, spread_degrees/2))
	
	$CooldownTimer.start(cast_cooldown if cast_cooldown > 0 else 0.01)
	
#	$CastSound.play()
	
