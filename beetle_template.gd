extends FlyingInsect

var count : int
@export var injured_texture : Texture2D
@export var injured_color : Color

func _init():
	template_name = "BeetleTemplate"
	score_value = 2 
	health = 2
	
func _on_injured():
	texture = injured_texture
	self.modulate.clamp(injured_color)
