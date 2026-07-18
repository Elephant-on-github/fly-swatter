extends Control
signal pause_timer(bool:bool)

var stop : bool = false
var flies : int
var beetles : int
var new_level : bool = true
var level : int = 0
var new_game : bool = true
var prize_selected : bool = false

@onready var leveltext = %LevelIndicator

# Called when the node enters the scene tree for the first time.
var sound = load("res://fly-swatter-2.mp3")
var sound2 = load("res://switch26.ogg")
var cash  = load("res://cash.mp3")
var sound_player := AudioStreamPlayer.new()

func _ready():
	visible = true #added by AI - Main starts invisible in scene, nothing was showing
	%prizes.visible = false
	%Start.visible = true
	%FailLabel.visible = false
	stop = true
	pause_timer.emit(true)
	leveltext.visible = false
	new_game = true
	add_child(sound_player) #fixed by ai - audio player must be in tree to play
	#leveltext.text = "[s][wave] Level " + str(level + 1) lower down

var spawn_timer: float = 0.0
var spawn_delay: float = 0.05

func _process(delta):
	if new_level:
		calc_number_spawn(level)
		print(beetles, flies)
		new_level = false
	if new_game and %Start.visible == false:
		%helpscreen.visible = true #mandatory help screen
		new_game = false
		stop = true
		pause_timer.emit(true)
	
	spawn_timer += delta
	if stop or %timer.num < 2:
		pass
	elif spawn_timer >= spawn_delay:
		if flies > 0:
			spawn_clone($FlyTemplate)
			flies -= 1
		#else: print("no more flies") #debug
		#BEETLE
		if beetles > 0:
			spawn_clone($BeetleTemplate)
			beetles -= 1
		#else: print("no more beetles") #debug
		# Reset the timer
		spawn_timer = 0.0

	if stop == false and Input.is_action_just_pressed("ui_accept"):
		sound_player.stream = sound
		sound_player.play()
	elif Input.is_action_just_pressed("ui_accept"): 
		sound_player.stream = sound2
		sound_player.play()
		
	if prize_selected == true:
		sound_player.stream = cash
		sound_player.play()
		prize_selected = false
		
	#fixed by ai - check for early round end after spawning is done
	var insects = get_tree().get_nodes_in_group("insects")
	if insects == [] and new_level == false and not stop and flies == 0 and beetles == 0:
		_on_label_finished()


func calc_number_spawn(levelint):
	flies = 8 * (1.2 ** levelint)
	beetles = 2 * (1.1 ** levelint)
	#wasps = 2 * (1.05 ** level)
	
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
	clone.collided.connect($swatter/swatterarea/squash._on_insect_collided) #fixed by ai - connect visual effects to collided signal
	clone.collided.connect($swatter/swatterarea/pulse.trigger_pulse) #fixed by ai - pulse on swat
	clone.collided.connect($swatter/swatterarea/pulse2.trigger_pulse) #fixed by ai - pulse2 on swat
	clone.add_to_group("insects")




func _on_label_finished():
	stop = true
	pause_timer.emit(true)
	var insects = get_tree().get_nodes_in_group("insects")
	if insects == []: 
		level += 1
		%timer.add_time(0.3)
		new_level = true
	else: 
	# print(insects, "melon") testing
		fail()
		return
	leveltext.visible = true
	leveltext.modulate.a = 1.0
	leveltext.text = "[s][wave] Level " + str(level)
	var tween = create_tween()
	tween.tween_property(leveltext, "modulate:a", 0.0, 0.7).set_trans(Tween.TRANS_SINE)
	await get_tree().create_timer(0.72).timeout
	leveltext.visible = false
	%prizes.visible = true
	%prizes.count = 0 #fixed by ai - reset escape counter when shop opens
	
	

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
	#stop = false
	#pause_timer.emit(false) moved down


func _on_helpscreen_closed():
	stop = false
	pause_timer.emit(false)
