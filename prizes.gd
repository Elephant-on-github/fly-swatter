extends Control

var count : int


signal escaped_prize
# Called when the node enters the scene tree for the first time.
# escape handling

func _process(delta):
	delta = delta
	# ^ get rid of warning
	if Input.is_action_just_pressed("ui_cancel"):
		escaped_prize.emit()
	if Input.is_action_just_pressed("ui_accept") and self.visible == true and !get_global_rect().has_point(get_global_mouse_position()):
		count +=1
		if count == 3:
			escaped_prize.emit()
			count = 0
