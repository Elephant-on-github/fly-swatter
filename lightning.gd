extends NinePatchRect

@onready var button = $Button
@onready var price_label = $Button/Label2
@onready var name_label = $Button/Label

var price : float = 250
var price_rounded : int
var level: int = 0
var disabled = true
var rangedist : int = 0 # number of flies targetted

signal Lightning_bought
signal Cost(cost:int)

# Called when the node enters the scene tree for the first time.
func _ready():
	price_label.text = str(price)
	name_label.text = "Lightning " + level_formatted(level)
	


func level_formatted(levelint) -> String :
	return "(" + str(levelint) + ")"


func _process(_delta):
	if int(%FlyCount.text) < price  or level >= 5:
		button.disabled = true
		disabled = true
		if level >= 5:
			name_label.text = "Lightning " + level_formatted("max")
	else:
		button.disabled = false
		disabled = false
		name_label.text = "Lightning " + level_formatted(level)
	price = 250 * (1.2 ** level) # calculate using float, then use int
	price_rounded = int(price)
	price_label.text = str(price_rounded)
	if Input.is_action_just_pressed("ui_accept") and get_global_rect().has_point(get_global_mouse_position()) and disabled == false and %prizes.visible == true:
		buy()

func reset_range():
	rangedist = level
func decrease_range():
	rangedist -= 1

func trigger_chain(_something, start_insect: FlyingInsect, _chain_kill := false) -> void: #added by AI - was Vector2, crashed because signal passes FlyingInsect #fixed by ai
	reset_range()
	var current_pos: Vector2 = start_insect.global_position #added by AI
	while rangedist > 0:
		var insects = get_tree().get_nodes_in_group("insects")
		var closest_insect: FlyingInsect = null
		var closest_dist: float = INF
		
		for insect in insects:
			if insect.name != insect.template_name and not insect.is_queued_for_deletion():
				var dist = current_pos.distance_to(insect.global_position)
				if dist < closest_dist:
					closest_dist = dist
					closest_insect = insect
		if closest_insect != null:
			_draw_bolt(current_pos, closest_insect.global_position)
			#fixed by ai - disconnect lightning from chain-killed insects to prevent recursive trigger_chain calls
			var cb := Callable(self, "trigger_chain")
			if closest_insect.collided.is_connected(cb):
				closest_insect.collided.disconnect(cb)
			closest_insect.collided.emit(null, closest_insect, true) #fixed by ai - chain_kill=true prevents score double-count
			closest_insect.queue_free()
			current_pos = closest_insect.global_position
			#fixed by ai - manually trigger visual effects for chain-killed insects
			var squash_node = get_tree().current_scene.find_child("squash", true, false)
			if squash_node:
				squash_node.trigger_at(closest_insect.global_position)
			var pulse_node = get_tree().current_scene.find_child("pulse", true, false)
			if pulse_node:
				pulse_node.trigger_pulse_at(closest_insect.global_position, randf_range(0.0, TAU))
			decrease_range()
			await get_tree().create_timer(0.06).timeout
		else:
			break

func _draw_bolt(from:Vector2, to: Vector2) -> void:
	var line = Line2D.new()
	line.default_color = Color.CYAN
	line.width = 3.0
	line.add_point(from)
	line.add_point(to)
	
	# Add it to the main scene tree root so it displays globally
	get_tree().current_scene.add_child(line) 
	
	await get_tree().create_timer(0.2).timeout
	line.queue_free()

func buy():
	Cost.emit(price_rounded)
	Lightning_bought.emit()
	rangedist += 1
	level += 1
	name_label.text = "Lightning " + level_formatted(level)
