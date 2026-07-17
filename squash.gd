extends Label

var collision_shape: CollisionShape2D



func _ready():
	if owner != null:
		collision_shape = %CollisionShapeSwatter

func trigger_pulse() -> void:
	var new_pulse = self.duplicate()
	get_parent().add_child(new_pulse)
	
	new_pulse.set_process_unhandled_input(false)
	new_pulse.set_process(false)
	
	new_pulse.scale = Vector2.ZERO
	new_pulse.modulate.a = 1.0
	new_pulse.visible = true
	new_pulse.global_position = collision_shape.global_position
	new_pulse.collision_shape = self.collision_shape
	new_pulse.rotation = randf_range(-45, 45)
	
	var tween = create_tween().set_parallel(true)
	tween.tween_property(new_pulse, "scale",Vector2(1.5,1.5), 0.4).set_trans(Tween.TRANS_SINE)
	tween.tween_property(new_pulse, "modulate:a", 0.0, 0.4).set_trans(Tween.TRANS_SINE)
	
	tween.chain().tween_callback(new_pulse.queue_free)


func _on_fly_template_collided(with_sprite):
	trigger_pulse()


func _on_beetle_template_collided(with_sprite):
	trigger_pulse()
