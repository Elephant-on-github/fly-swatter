@tool class_name AutoSizeLabel extends Label

var count = 0

@export var max_width: int = 400:
	get:
		return max_width
	set(value):
		max_width = value;
		_draw();

@export var expand_to_text_width: bool = false:
	get:
		return expand_to_text_width
	set(value):
		expand_to_text_width = value;
		_draw();

@export var min_size: int = 0:
	get:
		return min_size
	set(value):
		min_size = value;
		_draw();

@export var max_size: int = 16:
	get:
		return max_size
	set(value):
		max_size = value;
		_draw();

func _ready() -> void:
	size = Vector2.ZERO;

func _draw() -> void:
	size = Vector2.ZERO;
	# Calculate an appropriate font size based on the text width
	# Start with the maximum size and decrease towards min_size until it fits within max_width
	# if the text width for min_size still exceeds max_width, set to min_size
	# if min_size is larger than max_size, set to max_size
	
	var displayed_text := text;
	if visible_characters >= 0 && !expand_to_text_width:
		displayed_text = text.substr(0, visible_characters);
	
	# Ensure min_size doesn't exceed max_size
	var effective_min_size = min(min_size, max_size);
	var effective_max_size := max_size;
	
	# Start from max_size and work down to find the largest font size that fits
	var font := get_theme_font("font");
	var best_size = effective_min_size;
	
	for font_size in range(effective_max_size, effective_min_size - 1, -1):
		var text_size := font.get_string_size(displayed_text, horizontal_alignment, -1, font_size, justification_flags, text_direction as TextServer.Direction);
		if text_size.x <= max_width:
			best_size = font_size;
			break;
	
	# Apply the calculated font size
	add_theme_font_size_override("font_size", best_size);
	
	# Set custom minimum size based on actual text dimensions
	var final_text_size := font.get_string_size(displayed_text, horizontal_alignment, -1, best_size, justification_flags, text_direction as TextServer.Direction);
	custom_minimum_size = Vector2(min(final_text_size.x, max_width), 0);


func _on_fly_template_collided(with_sprite):
	count += 1 
	self.text = str(count)


func _on_bigger_container_cost(cost):
	count = count - cost
	self.text = str(count)
