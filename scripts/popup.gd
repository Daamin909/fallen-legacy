extends Panel
class_name TipPopup  # <- must be here

@onready var label: Label = $Label
var hide_timer: SceneTreeTimer = null

func show_popup(text: String, duration: float = 3.0):
	label.text = text
	show()
	position = Vector2(-300, 10)  # start offscreen



	# Tween slide in
	var tween = create_tween()
	tween.tween_property(self, "position", Vector2(10, 10), 0.3).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)

	# Hide after duration
	hide_timer = get_tree().create_timer(duration)
	hide_timer.timeout.connect(self._on_hide_timer_timeout)

func _on_hide_timer_timeout():
	var tween_out = create_tween()
	tween_out.tween_property(self, "position", Vector2(-300, 10), 0.3).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_IN)
	tween_out.finished.connect(self.hide)
