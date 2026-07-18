extends NinePatchRect

signal closed

var exit_count : int = 3

# Called when the node enters the scene tree for the first time.
func _ready():
	self.visible = false


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if self.visible == true and Input.is_action_just_pressed("ui_accept") and !get_global_rect().has_point(get_global_mouse_position()):
		if exit_count <= 0:
			self.visible = false
			closed.emit()
		else: exit_count -= 1 


func _on_button_pressed(): 
	# from help button
	self.visible = true
	exit_count = 3
