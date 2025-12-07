extends CanvasLayer
class_name TipPopup

@onready var panel: Panel = $Panel
@onready var label: Label = $Panel/Label

func show_popup(text: String, duration: float = 3.0):
	label.text = text
	panel.show()
	await get_tree().process_frame
	
	var screen_size = get_viewport().get_visible_rect().size
	var panel_size = Vector2(215, 100)
	var start_pos = Vector2(screen_size.x + 50, 10)
	var end_pos = Vector2(screen_size.x - panel_size.x - 10, 10)

	panel.global_position = start_pos

	var tween = create_tween()
	tween.tween_property(panel, "global_position", end_pos, 0.25)
	var timer = get_tree().create_timer(duration)
	timer.timeout.connect(_hide_popup)


func _hide_popup():
	var screen_size = get_viewport().get_visible_rect().size
	var exit_pos = Vector2(screen_size.x + 50, panel.global_position.y)

	var tween = create_tween()
	tween.tween_property(panel, "global_position", exit_pos, 0.25)
	tween.finished.connect(panel.hide)
