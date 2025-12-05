extends Panel

@onready var label = $RichTextLabel
@onready var button = $"../Button"


func _ready():
	button.visible = false
	label.position.y = 140
	var style = StyleBoxFlat.new()
	style.bg_color = Color(1, 1, 1, 0)
	add_theme_stylebox_override("panel", style)

	var tween = create_tween()
	tween.tween_property(label, "position:y", -200, 23) # change this once done

	tween.finished.connect(_on_text_scroll_done)

func _on_text_scroll_done():
	button.visible = true
	button.pressed.connect(_button_pressed)
	
func _button_pressed():
	get_tree().change_scene_to_file("res://scenes/playable_intro.tscn")
