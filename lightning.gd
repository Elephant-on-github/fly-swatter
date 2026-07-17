extends NinePatchRect

@onready var button = $Button
@onready var price_label = $Button/Label2
@onready var name_label = $Button/Label

var price : float = 100
var price_rounded : int
var level: int = 0
var disabled = true
var range : int = 0 # number of flies targetted

signal Lightning_bought
signal Cost(cost:int)

# Called when the node enters the scene tree for the first time.
func _ready():
	price_label.text = str(price)
	name_label.text = "Lightning " + level_formatted(level)
	


func level_formatted(level) -> String :
	return "(" + str(level) + ")"


func _process(delta):
	if int(%FlyCount.text) < price  or level >= 10:
		button.disabled = true
		disabled = true
		if level >= 10:
			name_label.text = "Lightning " + level_formatted("max")
	else:
		button.disabled = false
		disabled = false
		name_label.text = "Lightning " + level_formatted(level)
	price = 100 * (1.2 ** level) # calculate using float, then use int
	price_rounded = int(price)
	price_label.text = str(price_rounded)
	if Input.is_action_just_pressed("ui_accept") and get_global_rect().has_point(get_global_mouse_position()) and disabled == false and %prizes.visible == true:
		buy()

func reset_range():
	range = level
func decrease_range():
	range -= 1

func trigger_chain(_something, start_insect: FlyingInsect) -> void: #added by AI - was Vector2, crashed because signal passes FlyingInsect
	reset_range()
	var current_pos: Vector2 = start_insect.global_position #added by AI
	while range > 0:
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
			#added by AI - disconnect lightning from chain-killed insects to prevent recursive trigger_chain calls
			var cb := Callable(self, "trigger_chain")
			if closest_insect.collided.is_connected(cb):
				closest_insect.collided.disconnect(cb)
			closest_insect.collided.emit(null, closest_insect)
			closest_insect.queue_free()
			current_pos = closest_insect.global_position
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
	
	await get_tree().create_timer(0.1).timeout
	line.queue_free()

func buy():
	Cost.emit(price_rounded)
	Lightning_bought.emit()
	range += 1
	level += 1
	name_label.text = "Lightning " + level_formatted(level)
