extends Area2D


export var speed = 1.0
export var acceleration = 10.0
export var damping = 1.0

var linear_velocity = Vector2.ZERO


var target: Node2D
var initial_displacement: Vector2

func _ready():
	pass


func _physics_process(delta):
	
	# position should be 1 / speed - delta
	if target:
		var angle_to_target = (target.global_position - global_position).angle()
		linear_velocity = Vector2.RIGHT.rotated(angle_to_target) * max(1, linear_velocity.length())
		
		linear_velocity += linear_velocity.normalized() * delta * acceleration
		
#		linear_velocity += Vector2.RIGHT * acceleration
#		rotation = get_angle_to(target.position)
		linear_velocity = linear_velocity.clamped(target.global_position.distance_to(global_position))
		global_position += linear_velocity
		
		if global_position.distance_squared_to(target.global_position) < 256:
			queue_free()
			target.call_deferred("collect", self)

		return
#		linear_velocity = linea
#		lerp(initial_displacement, target.global_position, inverse_lerp())
#		global_position += (target.global_position - global_position) * 
		
	
#	if target:
#		return
		# go to player
#		linear_velocity += lerp(global_position, target.global_position, delta * speed) - global_position
#		global_position = lerp(global_position, target.global_position, delta * speed)
#		$Tween.tell()
		
	for b in get_overlapping_bodies():
		if b.is_in_group("player"):
			target = b
			initial_displacement = target.global_position - global_position
#			$Tween.targeting_property(self, "global_position", target, "global_position", target.global_position, 1)
#			$Tween.follow_property(self, "global_position", global_position, target, "global_position", speed)
#			$Tween.start()
			
#			yield($Tween, "tween_completed")
#			queue_free()
#			set_physics_process(false)
			return
			
			
##			var acceleration = b.get_scalar("")
#			var vec = b.global_position - global_position
#			vec = vec.normalized()
#			vec *= acceleration
#			vec *= delta
#
#			linear_velocity += vec
#
#	linear_velocity *= 1 - damping * delta
#	global_position += linear_velocity
#
#	global_rotation = linear_velocity.angle()





