extends FlyingInsect

var count : int
@export var injured_texture : Texture2D

func _init():
	template_name = "BeetleTemplate"
	score_value = 3 
	health = 3
	
func _on_injured():
	texture = injured_texture
