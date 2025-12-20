extends CanvasLayer
class_name TipPopup

@onready var panel: Panel = $Panel
@onready var label: Label = $Panel/Label
@onready var quest_sound := $Quest

func show_popup(
	text: String,
	duration: float = 3.0,
	width: float = 315.0,
	color: Color = Color("ff7a17")
):
	label.text = text

	# Width
	panel.custom_minimum_size.x = width
	panel.size.x = width

	# Color
	var style := panel.get_theme_stylebox("panel").duplicate()
	style.bg_color = color
	panel.add_theme_stylebox_override("panel", style)
	if color == Color("ff7a17"):	
		quest_sound.play()
	panel.show()
	await get_tree().process_frame

	var screen_size = get_viewport().get_visible_rect().size
	var panel_size = panel.size

	var start_pos = Vector2(screen_size.x + 50, 10)
	var end_pos = Vector2(screen_size.x - panel_size.x - 10, 10)

	panel.global_position = start_pos

	create_tween().tween_property(panel, "global_position", end_pos, 0.25)
	get_tree().create_timer(duration).timeout.connect(_hide_popup)

func _hide_popup():
	var screen_size = get_viewport().get_visible_rect().size
	var exit_pos = Vector2(screen_size.x + 50, panel.global_position.y)

	var tween = create_tween()
	tween.tween_property(panel, "global_position", exit_pos, 0.25)
	tween.finished.connect(panel.hide)
