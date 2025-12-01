extends Node2D


func _process(_delta: float) -> void:
	pass


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.name == "player_playable_intro":
		get_tree().change_scene_to_file("res://scenes/game_over.tscn")
