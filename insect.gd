class_name FlyingInsect 
extends Sprite2D

signal collided(with_sprite, type : FlyingInsect, chain_kill : bool) #fixed by ai


var template_name: String = ""
var score_value : int = 1
var active_tween: Tween
var slower : float = 2
var health :int = 1

# Called when the node enters the scene tree for the first time.
func _ready():
	start_moving_loop()




# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if template_name != "" and name == template_name:
		return
	# In the cloned sprite's script
	if Input.is_action_just_pressed("ui_select"):
		#%Lightning.reset_range() triggered elsewhere
		var overlapping = $Area2D.get_overlapping_areas() + $Area2D.get_overlapping_bodies()
		#print(overlapping) -> for debugging
		if overlapping.size() > 0:
			for other in overlapping:
				if other.name == "swatterarea":
					health -= 1
					if health <= 0:
						collided.emit(other, self, false) #fixed by ai
						queue_free()
						return
					else:
						_on_injured()
					

func start_moving_loop() -> void:
	var random_pos = Vector2(randf_range(350, get_viewport_rect().size.x - 20), 
					randf_range(20, get_viewport_rect().size.y - 20))
	
	var tween = self.create_tween()
	tween.tween_property(self, "position", random_pos, 1.0 * slower)
	
	# When this movement finishes, wait 0.2 seconds and run this function again!
	tween.finished.connect(func(): 
		get_tree().create_timer(0.2 * slower).timeout.connect(start_moving_loop)
	)
#^ (very little now) from the AI

func _on_injured():
	pass #set in extends


func _on_label_finished():
	if template_name != "" and name == template_name:
		return
	queue_free()
	
