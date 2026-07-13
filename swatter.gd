extends Sprite2D

signal prize_selected
@onready var collision = $swatterarea/CollisionShape2D

var scale2 : Vector2 = Vector2(1.0, 1.0)
var follow_speed = 100
func _ready():
	self.set_scale(scale2)
	collision.apply_scale(scale2)
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var target = get_global_mouse_position()
	self.position = self.position.lerp(target, follow_speed * delta)


func _on_bigger_size_pressed():
	collision.apply_scale(scale2 * 5)
	prize_selected.emit()
