extends Control

func _ready() -> void:
	pass 


func _process(delta: float) -> void:
	pass

func _on_button_pressed() -> void:
	SceneManager.change_scene("res://scenes/playable_intro.tscn")
