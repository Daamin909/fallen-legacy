extends CharacterBody2D

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.name == "player_playable_intro":
		get_tree().change_scene_to_file("res://scenes/home_village.tscn")
@onready var anim: Node2D = $Area2D/AnimatedSprite2D

func _ready() -> void:
	_play_idle()
	
func _play_idle():
	anim.play("idle")
