extends RigidBody2D


export var max_health = 1000
var health: int

var dmg_num_scene = preload("res://DamageNumber.tscn")

#var impulses = []


func _ready():
	$UI/HealthBar.min_value = 0
	$UI/HealthBar.max_value = max_health
	health = max_health


func _physics_process(delta):
#	for i in impulses:
#		apply_impulse(i[0], i[1])
#	impulses = []
	$UI/RayCast2D.cast_to = linear_velocity
	pass


#func hit(cast:CastProjectile, contact_point:Vector2):
#	pass

func hit(cast:CastProjectile, contact_point:Vector2):
	health -= cast.damage
#	impulses.append([
#		to_local(contact_point),
#		cast.vel.rotated(cast.global_rotation) * cast.payload["knockback"]
#	])
	var impulse_vec:Vector2 = cast.pos_step * cast.knockback
	var impulse_pos = to_local(contact_point).rotated(rotation)
	apply_impulse(impulse_pos, impulse_vec)

	# show impulse
#	var impulse_ray = load("res://RayIndicator.tscn").instance()
#	$"/root/World".add_child(impulse_ray)
#	$UI.add_child(impulse_ray)
#	impulse_ray.cast_to = direction
#	impulse_ray.position = contact_point

	var dmg_num = dmg_num_scene.instance()
	dmg_num.value = cast.damage
	$UI.add_child(dmg_num)
	
	$HealTimer.start()
	
	$AnimationPlayer.play("blink", -1, 4.0)
	$AnimationPlayer.seek(0)
	
#	$UI/Label.text = str(impulse_point)



func _process(delta):
	health = min(max(0, health), max_health)
	$UI/HealthBar.value = health
	
	if $HealTimer.is_stopped() and health < max_health:
		health += 1000 * delta


