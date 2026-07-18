extends Sprite2D

var collision_shape: CollisionShape2D

func _ready():
	if owner != null:
		collision_shape = %CollisionShapeSwatter

func trigger_pulse(_a="", _b="", _c="") -> void: #fixed by ai - accept signal args
	var new_pulse = self.duplicate()
	get_parent().add_child(new_pulse)
	
	new_pulse.set_process(false)
	
	new_pulse.scale = Vector2.ZERO
	new_pulse.modulate.a = 1.0
	new_pulse.visible = true
	new_pulse.global_position = collision_shape.global_position
	new_pulse.collision_shape = self.collision_shape
	new_pulse.rotation = randf_range(0.0, TAU)
	
	var target_scale : Vector2 = calculate_target_scale()
	if target_scale < Vector2(2,2):
		target_scale = calculate_target_scale()
	
	var tween = create_tween().set_parallel(true)
	tween.tween_property(new_pulse, "scale", target_scale, 0.4).set_trans(Tween.TRANS_SINE)
	tween.tween_property(new_pulse, "modulate:a", 0.0, 0.4).set_trans(Tween.TRANS_SINE)
	
	tween.chain().tween_callback(new_pulse.queue_free)

#fixed by ai - called by lightning chain for chain-killed insects
func trigger_pulse_at(pos: Vector2, rot: float) -> void:
	var new_pulse = self.duplicate()
	get_tree().current_scene.add_child(new_pulse)
	
	new_pulse.set_process(false)
	new_pulse.set_process_unhandled_input(false)
	
	new_pulse.scale = Vector2.ZERO
	new_pulse.modulate.a = 1.0
	new_pulse.visible = true
	new_pulse.global_position = pos
	new_pulse.collision_shape = self.collision_shape
	new_pulse.rotation = rot
	
	var target_scale : Vector2 = calculate_target_scale()
	if target_scale < Vector2(2,2):
		target_scale = calculate_target_scale()
	
	var tween = create_tween().set_parallel(true)
	tween.tween_property(new_pulse, "scale", target_scale, 0.4).set_trans(Tween.TRANS_SINE)
	tween.tween_property(new_pulse, "modulate:a", 0.0, 0.4).set_trans(Tween.TRANS_SINE)
	
	tween.chain().tween_callback(new_pulse.queue_free)

func calculate_target_scale() -> Vector2:
	var shape = collision_shape.shape
	var tex_size = texture.get_size()
	var shape_scale = collision_shape.scale / 2
	
	if shape is CircleShape2D:
		var factor = (shape.radius * 2.0 / tex_size.x) * shape_scale.x
		return Vector2(factor, factor)
		
	elif shape is RectangleShape2D:
		return Vector2(
			(shape.size.x / tex_size.x) * shape_scale.x,
			(shape.size.y / tex_size.y) * shape_scale.y
		)
		
	return Vector2(1.5, 1.5)
