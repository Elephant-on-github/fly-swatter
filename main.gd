extends Control
signal pause_timer(bool:bool)

var stop : bool
var flies : int
var beetles : int

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
		spawn_clone($FlyTemplate)
		
		#BEETLE
		spawn_clone($BeetleTemplate)
		# Reset the timer
		spawn_timer = 0.0


func calc_number_spawn(level):
	flies = 10 * (1.3 ** level)
	beetles = 5 * (1.2 ** level)
	#wasps = 2 * (1.1 ** level)
	
func spawn_clone(Template : FlyingInsect):
	var random_pos = Vector2(randf_range(350, get_viewport_rect().size.x - 20), 
							randf_range(20, get_viewport_rect().size.y - 20))

		# Create a duplicate of the sprite
	var clone = Template.duplicate()
	clone.visible = true
	%timer.finished.connect(clone._on_label_finished)
	clone.name = "clone"
	# Set its position to the random location
	clone.position = random_pos
	
	# Add it to the scene
	add_child(clone)
	clone.collided.connect(%FlyCount._on_insect_collided)
	clone.collided.connect(%Lightning.trigger_chain)
	clone.add_to_group("insects")


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
