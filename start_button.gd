extends TextureRect

@onready var button = $Button

signal start

var count : int

# Called when the node enters the scene tree for the first time.
func _ready():
	count = 5
	button.text = "Press Space " + "(" + str(count) + ")"
	self.pivot_offset = size / 2




# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("ui_select") and %helpscreen.visible == false :
		count -= 1
		button.text = "Press Space " + "(" + str(count) + ")"
		var tween = self.create_tween()
		tween.tween_property(self, "rotation", self.rotation + deg_to_rad(randf_range(-5, 5)), 0.1)
		tween.tween_property(self, "scale", Vector2(1.1, 1.1), 0.1)
		tween.tween_property(self, "scale", Vector2(1, 1), 0.1)
		tween.tween_property(self, "rotation", 0.0, 0.1)

		if count == 0:
			start.emit()
