extends Panel

@onready var label = $RichTextLabel

func _ready():
	label.position.y = 200

	var style = StyleBoxFlat.new()
	style.bg_color = Color(1, 1, 1, 0)  #
	add_theme_stylebox_override("panel", style)

	var tween = create_tween()
	tween.tween_property(label, "position:y", -200, 4)
