extends Control

func _ready() -> void:
	pass 


func _process(_delta: float) -> void:
	pass

func _on_button_pressed() -> void:
	SceneManager.change_scene("res://scenes/menu.tscn")
