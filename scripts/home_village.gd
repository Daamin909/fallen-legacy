extends Node2D

var home = "res://scenes/home.tscn"

func _ready():
	var p = $AudioStreamPlayer2D
	p.stream.set_loop(true)
	p.play()


func _on_door_area_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		SceneManager.change_scene(home)


func _on_door_area_body_entered(body: Node2D) -> void:
	print(body)
	PopupManager.show_popup("Click on the Door to Enter", 5.0)
