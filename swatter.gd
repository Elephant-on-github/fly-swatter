extends Sprite2D


@onready var collision = %CollisionShapeSwatter

var scale2 : Vector2 = Vector2(1.0, 1.0)
var follow_speed = 100
func _ready():
	self.set_scale(scale2)
	collision.apply_scale(scale2)
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var target = get_global_mouse_position()
	self.position = self.position.lerp(target, follow_speed * delta)

var base = 10.0
var level = 0
var multiplier = 1.14

func _on_bigger_container_bigger_bought():
	level += 1
	var target_radius = base * (multiplier ** level)
	self.apply_scale(Vector2(1.1,1.1))
	collision.shape.radius = target_radius
	print(collision.shape.radius)
