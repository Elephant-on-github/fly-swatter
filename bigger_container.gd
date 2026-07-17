extends NinePatchRect

@onready var button = $BiggerSize
@onready var price_label = $BiggerSize/Label2
@onready var name_label = $BiggerSize/Label
var price : float = 25
var price_rounded : int
var level: int = 0

signal Bigger_bought
signal Cost(cost:int)
signal prize_selected

var disabled : bool

# Called when the node enters the scene tree for the first time.
func _ready():
	price_label.text = str(price)
	name_label.text = "Squash More! " + level_formatted(level)
	


func level_formatted(levelint) -> String :
	return "(" + str(levelint) + ")"


func _process(_delta):
	if int(%FlyCount.text) < price or level >= 10:
		button.disabled = true
		disabled = true
		if level >= 10:
			name_label.text = "Squash More! " + level_formatted("max")
	else:
		button.disabled = false
		disabled = false
		name_label.text = "Squash More! " + level_formatted(level)
	price = 25 * (1.18 ** level) # calculate using float, then use int
	price_rounded = int(price)
	price_label.text = str(price_rounded)
	if Input.is_action_just_pressed("ui_accept") and get_global_rect().has_point(get_global_mouse_position()) and disabled == false and %prizes.visible == true:
		buy()

func buy():
	#upgrade
	Cost.emit(price_rounded)
	Bigger_bought.emit()
	prize_selected.emit()
	level += 1
	name_label.text = "Squash More! " + level_formatted(level)
	
