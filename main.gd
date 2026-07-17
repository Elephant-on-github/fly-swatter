extends Control
signal pause_timer(bool:bool)

var stop : bool

# Called when the node enters the scene tree for the first time.
func _ready():
	visible = true #added by AI - Main starts invisible in scene, nothing was showing
	%prizes.visible = false
	%Start.visible = true
	stop = true
	pause_timer.emit(true)

# Called every frame. 'delta' is the elapsed time since the previous frame.
var spawn_timer: float = 0.0
var spawn_delay: float = 0.1

func _process(delta):
	spawn_timer += delta
	if stop:
		pass
	elif spawn_timer >= spawn_delay:
		#FLY
		var random_pos = Vector2(randf_range(350, get_viewport_rect().size.x - 20), 
								 randf_range(20, get_viewport_rect().size.y - 20))

		# Create a duplicate of the sprite
		var fly_clone = $FlyTemplate.duplicate()
		fly_clone.visible = true
		%timer.finished.connect(fly_clone._on_label_finished)
		fly_clone.name = "clone"
		# Set its position to the random location
		fly_clone.position = random_pos
		
		# Add it to the scene
		add_child(fly_clone)
		fly_clone.collided.connect(%FlyCount._on_insect_collided)
		fly_clone.collided.connect(%Lightning.trigger_chain)
		fly_clone.add_to_group("insects")
		
		#BEETLE
		var random_pos2 = Vector2(randf_range(350, get_viewport_rect().size.x - 20), 
							 randf_range(20, get_viewport_rect().size.y - 20))

		# Create a duplicate of the sprite
		var beetle_clone = $BeetleTemplate.duplicate()
		beetle_clone.visible = true
		%timer.finished.connect(beetle_clone._on_label_finished)
		beetle_clone.name = "clone"
		# Set its position to the random location
		beetle_clone.position = random_pos2
		
		# Add it to the scene
		add_child(beetle_clone)
		
		beetle_clone.collided.connect(%FlyCount._on_insect_collided)
		beetle_clone.collided.connect(%Lightning.trigger_chain)
		beetle_clone.add_to_group("insects")
		
		# Reset the timer
		spawn_timer = 0.0


func _on_label_finished():
	%prizes.visible = true
	stop = true
	pause_timer.emit(true)
	

# superseded by escaping
#func _on_bigger_container_prize_selected():
	#%prizes.visible = false
	#stop = false
	#pause_timer.emit(false)


func _on_prizes_escaped_prize():
	%prizes.visible = false
	stop = false
	pause_timer.emit(false)


func _on_texture_rect_2_start():
	%Start.visible = false
	stop = false
	pause_timer.emit(false)
