extends Node

var tip_scene: PackedScene = preload("res://scenes/popup.tscn")
var current_tip: TipPopup = null

func show_popup(text: String, duration: float = 3.0):
	if not current_tip or not current_tip.is_inside_tree():
		current_tip = tip_scene.instantiate() as TipPopup
		get_tree().current_scene.add_child(current_tip)
	current_tip.show_popup(text, duration)
