extends RigidBody2D




export var size = 1.0
export var speed = 100.0
export var acceleration = 10.0
export var melee_damage = 10

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

var splat_scene = preload("res://enemy/zombie/Splat.tscn")

onready var health_max = 10 * size
onready var health_value = health_max
onready var player = $"/root/World/YSort/Player"


func _ready():
#	$CollisionShape2D = $CollisionShape2D.duplicate()
	$CollisionShape2D.shape.radius *= size
	$Body.scale *= size
	


func _process(delta):
	$Body.look_at(player.global_position)


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
	
	$UI/Health/Health.min_value = 0
	$UI/Health/Health.max_value = health_max
	$UI/Health/Health.value = health_value
	$UI/Health/HideTimer.unhide()
	
#	$AnimationPlayer.seek(0)
#	$AnimationPlayer.play("hit", -1)
	$"/root/World/YSort/Player/HalfMouse/Camera2D".raise_trauma(0.2)
	
	if health_value <= 0.0:
		call_deferred("destroy")
		$"/root/World/YSort/Player/HalfMouse/Camera2D".raise_trauma(0.4)
		



func destroy():
	var splat = splat_scene.instance()
	$"/root/World".add_child(splat)
	splat.global_transform = $Body.global_transform
	splat.rotate(PI)
#	splat.global_transform = global_transform
#	splat.rotate(PI)
	queue_free()
	pass



var noise = OpenSimplexNoise.new()

# Configure
#noise.seed = randi()
#noise.octaves = 4
#noise.period = 20.0
#noise.persistence = 0.8


func _integrate_forces(state):
#	var to_player: Vector2 = (player.global_position - global_position).normalized() * speed
	
#	print((state.linear_velocity + to_player).length())
#	if (state.linear_velocity + to_player).length() > state.linear_velocity.length():
#		state.linear_velocity += to_player - state.linear_velocity
	var to_player = (player.global_position - global_position).normalized() * acceleration
	
	
	for f in flockers:
		pass
		# TODO - flocking
	
	state.linear_velocity += to_player
#	state.linear_velocity += Vector2.RIGHT.rotated(noise.get_noise_1d(Engine.get_physics_frames()))
#	state.linear_velocity *= 0.6
#	state.linear_velocity += pid((state.linear_velocity - (player.global_position - global_position).normalized() * speed), state.step)
	
#	state.linear_velocity = (player.global_position - global_position).normalized() * speed
	pass


#	var dmg_num = dmg_num_scene.instance()
#	dmg_num.value = cast.damage
#	$UI.add_child(dmg_num)
	
#	$HealTimer.start()
	
#	$AnimationPlayer.play("blink", -1, 4.0)
#	$AnimationPlayer.seek(0)
	

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



func _on_FlockingArea_body_entered(body):
	if body.is_in_group("enemy"):
		flockers.append(body)
		# apply flocking
#		call_deferred()


func _on_FlockingArea_body_exited(body):
	if body.is_in_group("enemy"):
		flockers.remove(flockers.find(body))


func _on_AttackArea_body_entered(body):
	if body == player:
		injure(player)
		$AnimationPlayer.play("attack")
	pass # Replace with function body.
