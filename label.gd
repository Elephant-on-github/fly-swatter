extends Label
signal finished
var paused : bool

# Called when the node enters the scene tree for the first time.
func _ready():
	self.text = "0"

var count_to : float = 10
var num : float = count_to
var num2 : int
var _emitted_this_round : bool = false #fixed by ai - prevent re-emission

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if !paused:
		num -= delta
		num2 = int(num)
		if num2 <= 0 and not _emitted_this_round: #fixed by ai - guard against re-emission
			_emitted_this_round = true #fixed by ai
			finished.emit()
			self.text = str(num2)
			num = count_to
		else:
			self.text = str(num2)
	else:
		pass

func add_time(seconds : float):
	num += seconds
	count_to += seconds


func _on_main_pause_timer(paused_remote):
	paused = paused_remote
	if paused_remote == false:
		_emitted_this_round = false #fixed by ai - allow emission next round
		%Timericon.play("default")
		%Swattericon.play("default")
	else:
		%Timericon.pause()
		%Swattericon.pause()
