extends Control
signal pause_timer(bool:bool)

var stop : bool = false
var flies : int
var beetles : int
var new_level : bool = true
var level : int = 0

@onready var leveltext = %LevelIndicator

# Called when the node enters the scene tree for the first time.
func _ready():
	visible = true #added by AI - Main starts invisible in scene, nothing was showing
	%prizes.visible = false
	%Start.visible = true
	%FailLabel.visible = false
	stop = true
	pause_timer.emit(true)
	leveltext.visible = false
	#leveltext.text = "[s][wave] Level " + str(level + 1) lower down

# Called every frame. 'delta' is the elapsed time since the previous frame.
var spawn_timer: float = 0.0
var spawn_delay: float = 0.1

func _process(delta):
	if new_level:
		calc_number_spawn(level)
		print(beetles, flies)
		new_level = false
	
	spawn_timer += delta
	if stop:
		pass
	elif spawn_timer >= spawn_delay:
		if flies > 0:
			spawn_clone($FlyTemplate)
			flies -= 1
		
		#BEETLE
		if beetles > 0:
			spawn_clone($BeetleTemplate)
			beetles -= 1
		# Reset the timer
		spawn_timer = 0.0


func calc_number_spawn(levelint):
	flies = 10 * (1.3 ** levelint)
	beetles = 5 * (1.2 ** levelint)
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
	stop = true
	var insects = get_tree().get_nodes_in_group("insects")
	if insects == []: 
		level += 1
		%timer.add_time(1)
		new_level = true
	else: 
	# print(insects, "melon") testing
		fail()
	leveltext.visible = true
	leveltext.modulate.a = 1.0
	leveltext.text = "[s][wave] Level " + str(level)
	var tween = create_tween()
	tween.tween_property(leveltext, "modulate:a", 0.0, 0.7).set_trans(Tween.TRANS_SINE)
	await get_tree().create_timer(0.72).timeout
	leveltext.visible = false
	%prizes.visible = true
	
	pause_timer.emit(true)
	

func fail() -> void:
	%FailLabel.visible = true
	var format_text = '''
	[center][font_size=56][s][wave] Level %d [/wave][/s]
	[color=red]Fail[/color][/font_size]
	[hr]
	%d Flies killed
	%d upgrades purchased
	'''
	%FailLabel.text = format_text % [level,%FlyCount.running_total,%BiggerContainer.level + %Slower.level + %JucierContainer.level + %Lightning.level ]

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
