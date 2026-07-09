extends Control


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
var spawn_timer: float = 0.0
var spawn_delay: float = 0.1

func _process(delta):
	spawn_timer += delta
	
	if spawn_timer >= spawn_delay:
		# Get a random position on the screen
		var random_pos = Vector2(randf_range(0, get_viewport_rect().size.x), 
								 randf_range(0, get_viewport_rect().size.y))

		# Create a duplicate of the sprite
		var sprite_clone = $FlyTemplate.duplicate()
		sprite_clone.visible = true
		# Set its position to the random location
		sprite_clone.position = random_pos
		
		# Add it to the scene
		add_child(sprite_clone)
		
		# Reset the timer
		spawn_timer = 0.0
