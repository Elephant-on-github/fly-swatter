extends NinePatchRect

@onready var button = $Button
@onready var price_label = $Button/Label2
@onready var name_label = $Button/Label

var price : float = 50
var price_rounded : int
var level: int = 0
var disabled = true

signal Jucier_bought
signal Cost(cost:int)

# Called when the node enters the scene tree for the first time.
func _ready():
	price_label.text = str(price)
	name_label.text = "Jucier Flies " + level_formatted(level)
	


func level_formatted(levelint) -> String :
	return "(" + str(levelint) + ")"


func _process(_delta):
	if int(%FlyCount.text) < price  or level >= 10:
		button.disabled = true
		disabled = true
		if level >= 10:
			name_label.text = "Jucier Flies " + level_formatted("max")
	else:
		button.disabled = false
		disabled = false
		name_label.text = "Jucier Flies " + level_formatted(level)
	price = 50 * (1.2 ** level) # calculate using float, then use int
	price_rounded = int(price)
	price_label.text = str(price_rounded)
	if Input.is_action_just_pressed("ui_accept") and get_global_rect().has_point(get_global_mouse_position()) and disabled == false and %prizes.visible == true:
		buy()


func buy():
	Cost.emit(price_rounded)
	Jucier_bought.emit()
	level += 1
	name_label.text = "Jucier Flies " + level_formatted(level)
