extends Sprite2D

signal collided(with_sprite)

var active_tween: Tween

# Called when the node enters the scene tree for the first time.
func _ready():
	start_moving_loop()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if name == "BeetleTemplate":
		return
	# In the cloned sprite's script
	if Input.is_action_just_pressed("ui_select"):
		var overlapping = $Area2D.get_overlapping_areas() + $Area2D.get_overlapping_bodies()
		#print(overlapping) -> for debugging
		if overlapping.size() > 0:
			for other in overlapping:
				if other.name == "swatterarea":
					collided.emit(other)
					queue_free()
					return
					

func start_moving_loop() -> void:
	var random_pos = Vector2(randf_range(350, get_viewport_rect().size.x - 20), 
					randf_range(20, get_viewport_rect().size.y - 20))
	
	var tween = self.create_tween()
	tween.tween_property(self, "position", random_pos, 1.0)
	
	# When this movement finishes, wait 0.2 seconds and run this function again!
	tween.finished.connect(func(): 
		get_tree().create_timer(0.2).timeout.connect(start_moving_loop)
	)


func _on_label_finished():
	if name == "BeetleTemplate":
		return
	queue_free()
	
