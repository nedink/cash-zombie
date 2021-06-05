extends RigidBody2D




export var size = 1.0
export var speed = 100.0
export var acceleration = 10.0
export var melee_damage = 10

export var separation = 1.0
export var cohesion = 1.0
export var alignment = 1.0

export var can_flock = false



enum {
	IDLE,
	AGRO,
}

var state = AGRO

# PID controller - The gains are chosen experimentally
var Kp = 1.0
var Ki = 0.0
var Kd = 0.1

var prev_error = Vector2.ZERO
var P = Vector2.ZERO
var I = Vector2.ZERO
var D = Vector2.ZERO

func pid(current_error: Vector2, dt: float) -> Vector2:
	P = current_error
	I += P * dt;
	D = (P - prev_error) / dt;
	prev_error = current_error;
	
	return P*Kp + I*Ki + D*Kd;

var splat_scene = preload("res://enemy/zombie/Splat.tscn").instance()

onready var health_max = 10 * size
onready var health_value = health_max
onready var player = $"/root/World/YSort/Player"


func _ready():
#	$CollisionShape2D = $CollisionShape2D.duplicate()
	$CollisionShape2D.shape.radius *= size
	$Body.scale *= size
	$Separation.monitoring = can_flock
#	$Cohesion.monitoring = can_flock
#	$Alignment.monitoring = can_flock


func _process(delta):
#	$Body.look_at(player.global_position)
	pass


func _physics_process(delta):
#	$CollisionShape2D.shape.radius = base_radius * size
#	print($CollisionShape2D.shape.radius)
#	$Body.scale = Vector2.ONE * size
	pass
	
#	linear_velocity += Vector2(0.1, 0)
#	apply_impulse(Vector2.ZERO, Vector2(1 * delta, 1 * delta))
	
	if state == IDLE:
#		$Navigation2D.
		# wait for random time then walk random distance. Turn every so often
		# if detect player, switch to AGRO
		pass
	elif state == AGRO:
		# chase player while steering randomly
		
		
		var player_point:Vector2 = $"/root/World/YSort/Player".global_position
		if player_point.distance_to(global_position) > 100:
			state = IDLE
		else:
#			var path = Path2D.new()
#			add_child(path)
			pass
	
#	if $Body/AttackArea.overlaps_body(player):
		# attack
#		$AnimationPlayer.play("attack")
#		injure(player)
		


func hit(cast:CastProjectile, contact_point:Vector2):
	health_value -= cast.damage
	
	var impulse_vec:Vector2 = (cast.mass * cast.vel.length() * Vector2.RIGHT.rotated(cast.rotation)) + Vector2.RIGHT.rotated(cast.rotation) * cast.knockback
	var impulse_pos = to_local(contact_point).rotated(rotation)
	apply_impulse(impulse_pos, impulse_vec)
	
#	$UI/Health/Health.min_value = 0
#	$UI/Health/Health.max_value = health_max
#	$UI/Health/Health.value = health_value
	$UI/Health/HideTimer.unhide()
	
#	$AnimationPlayer.seek(0)
#	$AnimationPlayer.play("hit", -1)
	$"/root/World/YSort/Player/HalfMouse/Camera2D".raise_trauma(0.2)
	
	if health_value <= 0.0:
		call_deferred("destroy")
		$"/root/World/YSort/Player/HalfMouse/Camera2D".raise_trauma(0.2)
		
#	var dmg_num = dmg_num_scene.instance()
#	dmg_num.value = cast.damage
#	$UI.add_child(dmg_num)
	
#	$HealTimer.start()
	
#	$AnimationPlayer.play("blink", -1, 4.0)
#	$AnimationPlayer.seek(0)

#func get_splat_scene


func destroy():
	var splat = splat_scene.duplicate()
	
	$"/root/World".add_child(splat)
	splat.global_transform = $Body.global_transform
	splat.rotate(PI)
#	splat.global_transform = global_transform
#	splat.rotate(PI)
	queue_free()
	pass



#var noise = OpenSimplexNoise.new()

# Configure
#noise.seed = randi()
#noise.octaves = 4
#noise.period = 20.0
#noise.persistence = 0.8

func flocking(delta):
	var flock_vec = Vector2.ZERO
	
	# separation - displacements, summed, inverted, normalized
	var sep_vec = Vector2.ZERO
	# displacements, normalized, summed
	for pos in sep_flockers:
		var diff = global_position - pos.global_position
		diff = diff.normalized()
		diff /= max(global_position.distance_to(pos.global_position), 0.01)
		sep_vec += diff
		
	sep_vec = sep_vec.normalized()
	
	# inverted
#	sep_vec *= -1
	# normalized
#	sep_vec = sep_vec.normalized()
	# coef applied
	sep_vec *= separation
	flock_vec += sep_vec
	
	# cohesion - displacements, summed, averaged, normalized
	var coh_vec = Vector2.ZERO
	# displacements, summed
	for pos in coh_flockers:
		coh_vec += pos.global_position - global_position
	# averaged
	if coh_flockers:
		coh_vec /= coh_flockers.size()
	# normalized
	coh_vec = coh_vec.normalized()
	# coef applied
	coh_vec *= cohesion
#	flock_vec += coh_vec
	
#	# alignment - directions, summed, averaged, normalized
#	var ali_vec = Vector2.ZERO
#	# directions, summed
#	for vel in f_vel:
#		ali_vec += vel
#	# averaged
#	ali_vec /= f_vel.size()
#	# normalized
#	ali_vec = ali_vec.normalized()
#	ali_vec *= alignment
#	flock_vec += ali_vec
	flock_vec *= delta
	return flock_vec
	

func _integrate_forces(state):
	
	var vec = Vector2.ZERO
	
	# to player
	vec += (player.global_position - global_position).normalized()
	
	
	# FLOCKING 
	var flock_vec = flocking(state.step)
#	print(flock_vec)
	vec += flock_vec
	
	# get global transforms
#	var f_pos = []
#	for f in flockers:
#		 f_pos.append(f.global_position)
#	var f_vel = []
#	for f in flockers:
#		f_vel.append(f.linear_velcity)
	
	
	
	vec *= acceleration
	
	state.linear_velocity += vec
	
	var look_vec = Vector2.ZERO
	look_vec += state.linear_velocity.normalized()
	look_vec += (player.global_position - global_position).normalized()
	look_vec = look_vec.normalized()
	$Body.look_at(global_position + look_vec)
	

#var flocking_vec = Vector2.ZERO

var flockers = []

func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "attack":
		if $Body/AttackArea.get_overlapping_bodies():
			var potentials = []
			for body in $Body/AttackArea.get_overlapping_bodies():
				if body.is_in_group("player"):
					potentials.append(body)
			if potentials:
				var target = potentials[randi() % potentials.size()]
				injure(target)
				$AnimationPlayer.play("attack")


func injure(o: Node2D):
	var cast_projectile = CastProjectile.new()
	cast_projectile.damage = melee_damage
	cast_projectile.pos_step = Vector2.ZERO
	cast_projectile.knockback = 4.0
	var contact_point = $Body/AttackArea/CollisionShape2D.global_position
	o.hit(cast_projectile, contact_point)
	var fx_amt = lerp(0.3, 0.7, cast_projectile.damage / o.health_max)
	
#	fx_amt = min(fx_amt, 1)
#	print(melee_damage / o.health_max)
	$"/root/World/YSort/Player/HalfMouse/Camera2D".raise_trauma(fx_amt)
	
	cast_projectile.queue_free()



func _on_AttackArea_body_entered(body):
	if body == player:
		injure(player)
		$AnimationPlayer.play("attack")
	pass # Replace with function body.


var sep_flockers = []

func _on_Separation_body_entered(body):
	sep_flockers.append(body)

func _on_Separation_body_exited(body):
	sep_flockers.remove(sep_flockers.find(body))


var coh_flockers = []

func _on_Cohesion_body_entered(body):
	coh_flockers.append(body)

func _on_Cohesion_body_exited(body):
	coh_flockers.remove(coh_flockers.find(body))


# todo - position -> direction of movement
var ali_flockers = []

func _on_Alignment_body_entered(body):
	ali_flockers.append(body)

func _on_Alignment_body_exited(body):
	ali_flockers.remove(ali_flockers.find(body))
