extends Area2D


export (NodePath) var node_finder_path
onready var node_finder = get_node(node_finder_path)
onready var camera = node_finder.camera



func _on_ZoomArea_body_shape_entered(body_rid, body, body_shape_index, local_shape_index):
	if body.is_in_group("player"):
		
		var body_shape_owner_id = body.shape_find_owner(body_shape_index)
		var body_shape_owner = body.shape_owner_get_owner(body_shape_owner_id)
		var body_shape_2d = body.shape_owner_get_shape(body_shape_owner_id, 0)
		var body_global_transform = body_shape_owner.global_transform

		var area_shape_owner_id = shape_find_owner(local_shape_index)
		var area_shape_owner = shape_owner_get_owner(area_shape_owner_id)
		var area_shape_2d = shape_owner_get_shape(area_shape_owner_id, 0)
		var area_global_transform = area_shape_owner.global_transform
		
		camera.tween_zoom_to(Vector2.ONE * (1 + area_shape_owner.get_index() / 2.0))
#
#	var collision_points = area_shape_2d.collide_and_get_contacts(area_global_transform,
#									body_shape_2d,
#									body_global_transform)
