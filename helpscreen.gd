extends NinePatchRect


# Called when the node enters the scene tree for the first time.
func _ready():
	self.visible = false


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if self.visible == true and Input.is_action_just_pressed("ui_accept") and !get_global_rect().has_point(get_global_mouse_position()):
		self.visible = false


func _on_button_pressed(): 
	# from help button
	self.visible = true
