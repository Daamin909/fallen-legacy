extends Node2D

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body is CharacterBody2D:
		SceneManager.change_scene("res://scenes/corruptor_hq.tscn") # Replace with function body.
