extends Control

# Path to your first level scene

func _ready():
	$VBoxContainer/Button.pressed.connect(on_start_pressed)
	$VBoxContainer/Button2.pressed.connect(on_quit_pressed)

func on_start_pressed():
	SceneManager.change_scene("res://scenes/intro_cutscene.tscn")

func on_quit_pressed():
	get_tree().quit()
