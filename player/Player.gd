extends Area2D





var cast_state = CastState.IDLE


export var speed = 100

export var energy_max = 100
export var energy_recover_speed = 1.0
var energy_value = energy_max
var charge_value = 0

var pos_step = Vector2.ZERO
var joypad_controls = false

var dash_len = 100
var dashing = false


# energy/second
var charge_speed = 1.0



#func energy_post_charge():
#	return energy_value - charge_value


func primary_cast():
	return $Slots/Primary.get_child(0)


func _process(delta):
	if not joypad_controls:
#		look_at(get_global_mouse_position())
		$Body.look_at(get_global_mouse_position())
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
		modulate = Color(1, 1, 1, 0.8)
	else:
		modulate = Color(1, 1, 1, 1)
	


#func _draw():
#	draw_multiline($Body/Path2D.curve.get_baked_points(), $Body/Head.color, 5, true)
	




func _physics_process(delta):
	
	if dashing:
		return
	
	pos_step = Vector2.ZERO
	
	if Input.is_action_pressed("ui_up"):
		pos_step += Vector2.UP
	if Input.is_action_pressed("ui_down"):
		pos_step += Vector2.DOWN
	if Input.is_action_pressed("ui_left"):
		pos_step += Vector2.LEFT
	if Input.is_action_pressed("ui_right"):
		pos_step += Vector2.RIGHT
	
	pos_step = pos_step.normalized()
	
	if Input.is_action_just_pressed("dash") and $DashTimer.is_stopped():
		dashing = true
		$CollisionShape2D.set_deferred("disabled", true)
		$DashTween.interpolate_property(self, "position", position, position + (dash_len * pos_step.normalized()), 0.2, Tween.TRANS_LINEAR, Tween.EASE_OUT)
		$DashTween.start()
		$DashTimer.start()
	
	pos_step *= speed * delta
	
	position += pos_step

#func _physics_process(delta):
	# constants
#	$UI/ProgressBar.min_value = 0
#	$UI/ProgressBar.max_value = energy_max
#	$UI/ProgressBar.value = energy
	
	# cast state management
	
#	if cast_state == CastState.IDLE:
#		if Input.is_action_pressed("primary_cast"):
#			cast_state = primary_cast().process_state(cast_state, true)
##			state = next_state
#
#	if cast_state == CastState.PRIMARY:
#		primary_cast().process_state(cast_state, Input.is_action_pressed("primary_cast"))
	
	
#	if primary_cast().get_node("CooldownTimer").is_stopped():
#		print("stopped")
	
	
	process_cast_state(delta)
	
	




func process_cast_state(delta):
	if cast_state == CastState.IDLE:
		if Input.is_action_pressed("primary_cast") and energy_value >= primary_cast().energy_drain and primary_cast().get_node("CooldownTimer").is_stopped():
			cast_state = CastState.CHARGING
#			charge_value += charge_initial
			process_cast_state(delta)
			return
		energy_value += energy_recover_speed * delta
		energy_value = min(energy_value, energy_max)
		return
	if cast_state == CastState.CHARGING:
#		if automatic and charge_value >= charge_required:
		if int(charge_value):
			cast_state = CastState.FIRING
#			release()
			return
#		if not Input.is_action_pressed("primary_cast"):
#			if charge_value >= primary_cast().charge_required:
#				cast_state = CastState.FIRING
#				_physics_process(delta)
#				return
#			else:
#				charge(delta)
#				return
		else:
			# check that there is still energy left post-cast
			if energy_value - primary_cast().energy_drain <= 0:
				cancel_charge()
				cast_state = CastState.IDLE
			else:
				charge(delta)
				pass
		return
	if cast_state == CastState.FIRING:
		release()
#		if Input.is_action_pressed("primary_cast"):
#			cast_state = CastState.CHARGING
#			return
		cast_state = CastState.IDLE
		return
#	if cast_state == CastState.JUST_FIRED:
#		cast_state = CastState.IDLE
#		_physics_process(delta)
#		return
	
	if cast_state == CastState.MAX_CHARGE:
		return



func charge(delta):
	charge_value += primary_cast().total_charge_speed() * delta
#	charge_value = min(charge_value, primary_cast().charge_required)
#	$ChargeFx.charging(charge_value)
#	if charge_value < charge_max:
#		$ChargeFx.charging(charge_value)
#	else:
#		$ChargeFx.max_charge()

func cancel_charge():
#	$ChargeFx.cancel()
	charge_value = 0


func release():
	energy_value -= primary_cast().energy_drain
	energy_value = max(energy_value, 0)
	primary_cast().call_deferred("cast")
	charge_value = 0
#	$ChargeFx.release()
#	primary_cast().get_node("CooldownTimer").start(primary_cast().cast_cooldown if primary_cast().cast_cooldown > 0 else 0.01)





func _input(event):
	if event is InputEventMouse:
		joypad_controls = false
	if event is InputEventJoypadButton or event is InputEventJoypadMotion:
		# TODO - implement deadzone. otherwise this will continuously happen
		joypad_controls = true


func _on_DashTween_tween_completed(object, key):
	dashing = false
