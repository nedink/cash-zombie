extends PrimaryCast


class_name OrbCast





export var cast_cooldown = 0.25
export var spread_degrees = 10
export var automatic = true



export var energy_drain = 5.0

#export var charge_required = 1.0
#export var charge_min = 1.0
#export var charge_max = 1.0
export var charge_speed = 5.0
#export var charge_initial = 0.0

#export var charge_damage = 2
#export var charge_velocity = 2

# payload
export var velocity = 800
export var damping = 2.0
export var damage = 5
export var size = 1.0
#export var impact_force= 10
export var life_time = 1.0
#export var knockback = 1.0


var charge_value = 0



var projectile_scene:PackedScene = load("res://cast/orb/OrbProjectile.tscn")

# Caster/Slots/Primary/@
onready var caster = get_parent().get_parent().get_parent()



#func _ready():
#	payload = payload.duplicate()


func pos_step():
	return caster.pos_step


func total_charge_speed():
	return charge_speed * caster.charge_speed


#func time_to_charge_min():
#	return charge_min / charge_speed()

#func get_charge_value():
#	return get_parent().charge_value
#
#
#func get_energy_value():
#	return get_parent().energy_value
#
#
#func set_energy_value(value):
#	get_parent().energy_value = value


#func energy_post_charge():
#	return energy_value() - charge_value










#func release():
#	energy -= charge_value
#	call_deferred("emit_projectile")
##	emit_projectile()
#	charge_value = 0
#	$ChargeFx.release()
#	$CastCooldown.start(cast_cooldown if cast_cooldown > 0 else 0.01)
	






#func emit_projectile():
func cast():
	var projectile = projectile_scene.instance()
#	projectile.caster = self
#	projectile.payload = payload
	$"/root/World".add_child(projectile)
	projectile.global_transform = caster.get_node("Body/CastPoint").global_transform
	projectile.vel = Vector2.RIGHT * velocity + pos_step()
	projectile.damping = damping
	projectile.damage =  damage
	projectile.size = size
	
#	var dmg = [1, 10, 100, 1000, 10000] 
#	projectile.damage = dmg[rand_range(0, 5)]
	
	# charge effects
	projectile.scale = Vector2.ONE * max(1, charge_value)
	
	# spread
#	projectile.rotation += deg2rad(rand_range(-spread_degrees/2, spread_degrees/2))
	
	$CooldownTimer.start(cast_cooldown if cast_cooldown > 0 else 0.01)
	
