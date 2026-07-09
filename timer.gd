extends Timer
signal counted_down(number)
signal counter2(num)

@export var _count := 5

# Called when the node enters the scene tree for the first time.

func _on_timeout() -> void:

	counted_down.emit(_count)

	_count -= 1

	if _count < 0:
		stop()

var counter : int

func _process(delta):
	counter += delta
	counter2.emit(counter)
	if counter == 5:
		counter = 0
