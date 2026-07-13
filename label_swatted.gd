extends Label
var count = 0


# Called when the node enters the scene tree for the first time.
func _on_fly_template_collided(with_sprite):
	count += 1 
	self.text = str(count)
