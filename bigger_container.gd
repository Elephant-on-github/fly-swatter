extends NinePatchRect

@onready var button = $BiggerSize
@onready var price_label = $BiggerSize/Label2
@onready var name_label = $BiggerSize/Label
var price : float = 10
var price_rounded : int
var level: int = 0

signal Bigger_bought
signal Cost(cost:int)
signal prize_selected

# Called when the node enters the scene tree for the first time.
func _ready():
	price_label.text = str(price)
	name_label.text = "Bigger " + level_formatted(level)
	


func level_formatted(level) -> String :
	return "(" + str(level) + ")"


func _process(delta):
	if int(%FlyCount.text) < price:
		button.disabled = true
	else:
		button.disabled = false
	price = 10 * (1.18 ** level) # calculate using float, then use int
	price_rounded = int(price)
	price_label.text = str(price_rounded)
	name_label.text = "Bigger " + level_formatted(level)

func _on_bigger_size_pressed():
	#upgrade
	Cost.emit(price_rounded)
	Bigger_bought.emit()
	prize_selected.emit()
	level += 1
