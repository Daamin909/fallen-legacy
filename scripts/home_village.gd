extends Node2D

var home = "res://scenes/home.tscn"

func _ready():
	var p = $AudioStreamPlayer2D
	p.stream.set_loop(true)
	p.play()

func _on_door_area_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		SceneManager.change_scene(home)


func _on_door_area_body_entered(_body: Node2D) -> void:
	PopupManager.show_popup("Click on the Door to Enter", 4.0, 270, Color("#00b9b6"))
