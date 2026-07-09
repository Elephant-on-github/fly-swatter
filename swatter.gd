extends Sprite2D

var scale2 : Vector2 = Vector2(1.0, 1.0)
var follow_speed = 100
func _ready():
	self.set_scale(scale2)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var target = get_global_mouse_position()
	self.position = self.position.lerp(target, follow_speed * delta)
