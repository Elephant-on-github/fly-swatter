extends Control

var stop : bool

# Called when the node enters the scene tree for the first time.
func _ready():
	%prizes.visible = false


# Called every frame. 'delta' is the elapsed time since the previous frame.
var spawn_timer: float = 0.0
var spawn_delay: float = 0.1

func _process(delta):
	spawn_timer += delta
	if stop:
		pass
	elif spawn_timer >= spawn_delay:
		# Get a random position on the screen
		var random_pos = Vector2(randf_range(350, get_viewport_rect().size.x - 20), 
								 randf_range(20, get_viewport_rect().size.y - 20))

		# Create a duplicate of the sprite
		var sprite_clone = $FlyTemplate.duplicate()
		sprite_clone.visible = true
		%timer.finished.connect(sprite_clone._on_label_finished)
		sprite_clone.name = "clone"
		# Set its position to the random location
		sprite_clone.position = random_pos
		
		# Add it to the scene
		add_child(sprite_clone)
		
		# Reset the timer
		spawn_timer = 0.0


func _on_label_finished():
	%prizes.visible = true
	stop = true
	


func _on_swatter_prize_selected():
	%prizes.visible = false
	stop = false
