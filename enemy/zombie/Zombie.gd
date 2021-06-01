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


onready var health_max = 10 * size
onready var health_value = health_max
onready var player = $"/root/World/Player"


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
		
		
		var player_point:Vector2 = $"/root/World/Player".global_position
		if player_point.distance_to(global_position) > 100:
			state = IDLE
		else:
#			var path = Path2D.new()
#			add_child(path)
			pass
	
	if $Body/AttackArea.overlaps_body(player):
		# attack
		$AnimationPlayer.play("attack")
		
	




func hit(cast:CastProjectile, contact_point:Vector2):
	health_value -= cast.damage
	
#	print(cast.knockback)
#	print(cast.pos_step)
	
#	print(cast.pos_step.normalized())
#	print(cast.rotation)
	var impulse_vec:Vector2 = (cast.mass * cast.vel.length() * Vector2.RIGHT.rotated(cast.rotation)) + Vector2.RIGHT.rotated(cast.rotation) * cast.knockback
	print(impulse_vec)
	var impulse_pos = to_local(contact_point).rotated(rotation)
	apply_impulse(impulse_pos, impulse_vec)
	
	$UI/Health.min_value = 0
	$UI/Health.max_value = health_max
	$UI/Health.value = health_value
	$UI/Health/HideTimer.unhide()
#	$AnimationPlayer.seek(0)
#	$AnimationPlayer.play("hit", -1)
	$"/root/World/Player/HalfMouse/Camera2D".raise_trauma(0.2)




func _integrate_forces(state):
#	var to_player: Vector2 = (player.global_position - global_position).normalized() * speed
	
#	print((state.linear_velocity + to_player).length())
#	if (state.linear_velocity + to_player).length() > state.linear_velocity.length():
#		state.linear_velocity += to_player - state.linear_velocity
	
	state.linear_velocity += (player.global_position - global_position).normalized() * acceleration
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
	


func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "attack":
		if $Body/AttackArea.overlaps_body(player):
			print("attack")
			var cast_projectile = CastProjectile.new()
			cast_projectile.damage = melee_damage
			cast_projectile.pos_step = Vector2.ZERO
			cast_projectile.knockback = 4.0
			var contact_point = $Body/AttackArea/CollisionShape2D.global_position
			player.hit(cast_projectile, contact_point)
