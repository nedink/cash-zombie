extends Area2D


class_name CastProjectile


export var explosion_scene: PackedScene

var vel:Vector2 = Vector2.ZERO
var vel_step:Vector2 = Vector2.ZERO
var pos_step:Vector2 = Vector2.ZERO
var damping = 1.0
var damage = 1.0
var mass = 0.0
var knockback = 0.0
var size = 1.0
var life_time = 1.0
var collided_once = false
var dead = false

onready var shape:CircleShape2D = $CollisionShape2D.shape


func _ready():
	$LifeTimer.wait_time = life_time
	$CollisionShape2D.position.x = shape.radius
	
	$LifeTimer.start()
#	print($LifeTimer.wait_time)



func _process(delta):
	if not dead:
		scale = Vector2.ONE * size
		$FX.scale.x = max(1, vel_step.length() / 8)
#		$FX.scale.y = clamp(1/$FX.scale.x, 0, 1)
#		var modul = rand_range(0, 0.3)
#		$FX.modulate.r = 1 + modul
#		$FX.modulate.g = 1 + modul
#		$FX.modulate.b = 1 + modul
		


var collision_point = Vector2.ZERO

func _physics_process(delta):
	
	position += pos_step
	
	vel *= 1 - damping * delta
	
	vel_step = vel * delta
	
	
	if not do_collision($LeftEdge):
		do_collision($RightEdge)
	
	pos_step = vel_step.rotated(rotation)
	
	


var collider
func do_collision(raycast:RayCast2D) -> Vector2:
	if collided_once:
		return Vector2.ZERO
#	raycast.enabled = vel_step.length() >= 16
	raycast.cast_to.x = max($CollisionShape2D.shape.radius * 2, vel_step.length())
	if raycast.is_colliding():
		collided_once = true
		collider = raycast.get_collider()
		var my_position = global_position + (raycast.get_collision_point() - raycast.global_position)
		on_hit(collider, my_position)
		return my_position
	return Vector2.ZERO





func _on_VisibilityNotifier2D_screen_exited():
	queue_free()


func _on_OrbProjectile_body_shape_entered(body_rid, body, body_shape_index, local_shape_index):
	
	if collided_once:
		return
	
	collided_once = true
	
#	var body_shape_owner_id = body.shape_find_owner(body_shape)
#	var body_shape_owner = body.shape_owner_get_owner(body_shape_owner_id)
#	var body_shape_2d = body.shape_owner_get_shape(body_shape_owner_id, 0)
#	var body_global_transform = body_shape_owner.global_transform
#
#	var area_shape_owner_id = shape_find_owner(local_shape)
#	var area_shape_owner = shape_owner_get_owner(area_shape_owner_id)
#	var area_shape_2d = shape_owner_get_shape(area_shape_owner_id, 0)
#	var area_global_transform = area_shape_owner.global_transform
#
#	var collision_points = area_shape_2d.collide_and_get_contacts(area_global_transform,
#									body_shape_2d,
#									body_global_transform)
	
#	var hit_point = Utils.avg(collision_points)
#	var hit_point = collision_points[len(collision_points) - 1] if collision_points else global_position
#	var explode_point = global_position
#	if collision_points:
#		hit_point = collision_points[0]
	
	on_hit(body, global_position)
	
	


func on_hit(body, point: Vector2):
#	print("OrbProjectile on_hit " + body.name)
#	$FX.hide()
#	update()
	if body.has_method("hit"):
		call_deferred("explode", point)
		
		body.hit(self, point)
		
		queue_free()



func explode(point: Vector2):
	var explosion:Node2D = explosion_scene.instance()
	$"/root/World".add_child(explosion)
#	explosion.global_transform = global_transform
	explosion.global_position = point
#	explosion.global_position = global_position
	explosion.scale = scale
	pass


func destroy():
	dead = true
	set_process(false)
	$DeathTween.interpolate_property($FX, "scale", $FX.scale, Vector2.ZERO, 0.2)
	$DeathTween.start()
	yield($DeathTween, "tween_completed")
	queue_free()


