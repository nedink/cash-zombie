extends KinematicBody2D


export var speed = 100
export var health_max = 100
export var energy_max = 5
export var energy_recover_speed = 10.0
export var charge_speed = 1.0  # energy/second
export var dash_len = 100
export var dash_time = 0.25
export var damping = 0.1

var pos_step = Vector2.ZERO
var joypad_controls = false
var dashing = false
var dash_direction = Vector2.RIGHT
var cast_state = Cast.State.IDLE
#var mouse_down = true

onready var charge_value = 0
onready var energy_value = energy_max
onready var health_value = health_max

onready var reticle_manager = $"/root/World/ReticleManager"



func current_cast():
	return $Slots/Primary.get_child(0)


func _process(delta):
	if not joypad_controls:
		$Body.look_at(reticle_manager.reticle().global_position)
	else:
		var deadzone = 0.5
		var controllerangle = Vector2.ZERO
		var xAxisRL = Input.get_joy_axis(0, JOY_AXIS_2)
		var yAxisUD = Input.get_joy_axis(0 ,JOY_AXIS_3)
		if abs(xAxisRL) > deadzone || abs(yAxisUD) > deadzone:
			var controller_angle = Vector2(xAxisRL, yAxisUD).angle()
#			$Body.rotation = controller_angle
			rotation = controller_angle
			
	
	if Input.is_action_pressed("ui_up") or Input.is_action_pressed("ui_down") or Input.is_action_pressed("ui_left") or Input.is_action_pressed("ui_right"):
#		$AnimationPlayer.play("shoot")
		if Input.is_action_pressed("primary_cast"):
			$AnimationPlayer.play("shoot")
		else:
			$AnimationPlayer.play("walk")
	else:
		if Input.is_action_pressed("primary_cast"):
			$AnimationPlayer.play("shoot")
		else:
			$AnimationPlayer.play("walk")
			$AnimationPlayer.seek(0.25)
#		$AnimationPlayer.play("walk")
#		$AnimationPlayer.seek(0.3)
	
	if dashing:
		modulate = Color(1, 1, 1, 0.7)
	else:
		modulate = Color(1, 1, 1, 1)
	


func _physics_process(delta):
	
	if dashing:
		return
	
#	pos_step = Vector2.ZERO
	var input_step = Vector2.ZERO
	
	if Input.is_action_pressed("ui_up"):
		input_step += Vector2.UP
	if Input.is_action_pressed("ui_down"):
		input_step += Vector2.DOWN
	if Input.is_action_pressed("ui_left"):
		input_step += Vector2.LEFT
	if Input.is_action_pressed("ui_right"):
		input_step += Vector2.RIGHT
	
	input_step = input_step.normalized()
	
	if Input.is_action_just_pressed("dash") and $DashTimer.is_stopped():
		dashing = true
		$CollisionShape2D.set_deferred("disabled", true)
		var direction = dash_direction
		if input_step.normalized().length():
			direction = input_step.normalized()
		dash_direction = direction
		$DashTween.interpolate_property(self, "position", position, position + (dash_len * direction), dash_time, Tween.TRANS_LINEAR, Tween.EASE_OUT)
		$DashTween.start()
		$DashTimer.start()
		
#		dash_len = input_step.normalized()
	
#	input_step *= speed * delta
	input_step *= speed
	
	pos_step = input_step
#	if pos_step.length() > input_step.length():
#		pos_step *= (1 - damping * delta)
	
	var disp = move_and_slide(pos_step)
	if disp.length() < pos_step.length():
		move_and_slide(pos_step.normalized() * (pos_step.length() - disp.length()))
	
	process_cast_state(delta)


func _integrate_forces(state):
#	state.linear_velocity = Vector2.ZERO
#	var vel_len = state.linear_velocity.length()
	
#	if (state.linear_velocity + pos_step) <= state.linear_velocity:
#		state.linear_velocity += pos_step
		
#	if state.linear_velocity.length() < pos_step.length():
		
#	state.linear_velocity = pos_step
#	state.linear_velocity += pos_step
	
	pass

	
	




func process_cast_state(delta):
	# reticle
	if cast_state == Cast.State.CHARGING:
		current_cast().reticle.set_state(cast_state, charge_value)
	else:
		current_cast().reticle.set_state(cast_state)
	
	if cast_state == Cast.State.IDLE:
		var should_cast = Input.is_action_pressed("primary_cast") if current_cast().automatic else Input.is_action_just_pressed("primary_cast")
		should_cast = should_cast and energy_value >= current_cast().energy_drain and current_cast().get_node("CooldownTimer").is_stopped()
		
		if should_cast:
			if current_cast().chargeable:
				cast_state = Cast.State.CHARGING
				process_cast_state(delta)
			else:
				release()
#				if current_cast().automatic:
#					cast_state = Cast.State.IDLE
#				else:
#					cast_state = Cast.State.AWAIT_UNACTION
			return
		energy_value += energy_recover_speed * delta
		energy_value = min(energy_value, energy_max)
		return
	if cast_state == Cast.State.CHARGING:
#		if automatic and charge_value >= charge_required:
		if charge_value >= 1.0:
			release()
#			if current_cast().automatic
#			cast_ready = current_cast().automatic
#			if current_cast().automatic:
#				cast_state = Cast.State.IDLE
#			else:
#				cast_state = Cast.State.AWAIT_UNACTION
			return
#		if not Input.is_action_pressed("primary_cast"):
#			if charge_value >= current_cast().charge_required:
#				cast_state = Cast.State.FIRING
#				_physics_process(delta)
#				return
#			else:
#				charge(delta)
#				return
		else:
			# check that there is still energy left post-cast
			if energy_value - current_cast().energy_drain <= 0:
				cancel_charge()
				cast_state = Cast.State.IDLE
			else:
				charge(delta)
				pass
		return
	if cast_state == Cast.State.AWAIT_UNACTION:
		if not Input.is_action_pressed("primary_cast"):
			cast_state = Cast.State.IDLE
		return
	if cast_state == Cast.State.FIRING:
#		release()
#		if Input.is_action_pressed("primary_cast"):
#			cast_state = Cast.State.CHARGING
#			return
		cast_state = Cast.State.IDLE
		process_cast_state(delta)
		return
#	if cast_state == Cast.State.JUST_FIRED:
#		cast_state = Cast.State.IDLE
#		_physics_process(delta)
#		return
	
	if cast_state == Cast.State.MAX_CHARGE:
		return


func current_charge_speed():
	return charge_speed * current_cast().charge_speed


func charge(delta):
	charge_value += current_charge_speed() * delta
#	charge_value = min(charge_value, current_cast().charge_required)
	$Body/ChargeFx.charging(charge_value)
#	energy_value -= charge_value * current_cast().energy_drain 
#	if charge_value < charge_max:
#		$ChargeFx.charging(charge_value)
#	else:
#		$ChargeFx.max_charge()

func cancel_charge():
	$Body/ChargeFx.cancel()
	charge_value = 0


func release():
	energy_value -= current_cast().energy_drain
	energy_value = max(energy_value, 0)
	current_cast().call_deferred("cast", charge_value)
	charge_value = 0
	$Body/ChargeFx.release()
	$HalfMouse/Camera2D.raise_trauma(0.1)
	
	
#	current_cast().get_node("CooldownTimer").start(current_cast().cast_cooldown if current_cast().cast_cooldown > 0 else 0.01)


func hit(cast:CastProjectile, contact_point:Vector2):
	health_value -= cast.damage
#	print(health_value)
	
	var impulse_vec:Vector2 = cast.pos_step + (cast.pos_step.normalized() * cast.knockback)
	var impulse_pos = to_local(contact_point).rotated(rotation)
#	apply_impulse(impulse_pos, impulse_vec)
	
	
#	$UI/Health.min_value = 0
#	$UI/Health.max_value = health_max
#	$UI/Health.value = health
#	$UI/Health/HideTimer.unhide()
#	$AnimationPlayer.seek(0)
#	$AnimationPlayer.play("hit", -1, 5.0)
#	$"/root/World/Player/HalfMouse/Camera2D".raise_trauma(0.2)


func _input(event):
	if event is InputEventMouse:
		joypad_controls = false
	if event is InputEventJoypadButton or event is InputEventJoypadMotion:
		# TODO - implement deadzone. otherwise this will continuously happen
		joypad_controls = true


func _on_DashTween_tween_completed(object, key):
	dashing = false


func energy_value_post_charge():
	return energy_value - charge_value * current_cast().energy_drain


func _on_DashTimer_timeout():
	$CollisionShape2D.set_deferred("disabled", false)
