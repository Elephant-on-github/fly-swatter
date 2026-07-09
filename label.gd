extends Label
signal finished

# Called when the node enters the scene tree for the first time.
func _ready():
	self.text = "0"

var num : float = 10
var num2 : int

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	num -= delta
	num2 = int(num)
	if num2 == 0: 
		finished.emit()
		num = 10
	else:
		self.text = str(num2)
