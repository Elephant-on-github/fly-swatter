extends Label
signal finished
var paused : bool

# Called when the node enters the scene tree for the first time.
func _ready():
	self.text = "0"

var count_to = 10
var num : float = count_to
var num2 : int

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if !paused:
		num -= delta
		num2 = int(num)
		if num2 <= 0: 
			finished.emit()
			self.text = str(num2)
			num = count_to + 0.2
		else:
			self.text = str(num2)
	else:
		pass

func add_time(seconds : int):
	num += seconds
	count_to += seconds


func _on_main_pause_timer(paused_remote):
	paused = paused_remote
	if paused_remote == false:
		%Timericon.play("default")
		%Swattericon.play("default")
	else:
		%Timericon.pause()
		%Swattericon.pause()
