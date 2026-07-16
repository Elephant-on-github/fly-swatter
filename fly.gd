extends Sprite2D

signal collided(with_sprite)


# Called when the node enters the scene tree for the first time.
func _ready():
	# print(self.name)
	pass # Replace with function body.



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if name == "FlyTemplate":
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
#^ (partially) from the AI


func _on_label_finished():
	if name == "FlyTemplate":
		return
	queue_free()
	
