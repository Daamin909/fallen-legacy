extends Node2D

var home_village = "res://scenes/home_village.tscn"
@onready var player_sprite = $Player/AnimatedSprite2D
@onready var player = $Player

func _ready():
	if SceneManager.is_player_position_inside_home_right:
		SceneManager.is_player_position_inside_home_right = false
		await get_tree().create_timer(0.5).timeout
		PopupManager.show_popup("Quest Added: Talk to Village Elder", 4.0, 345)
	else:
		call_deferred("_set_initial_position")

func _do_thingy() -> void:
	SceneManager.preload_scene(home_village)
	pass

func _set_initial_position():
	player.position = Vector2(-280, -10)


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body is CharacterBody2D:
		call_deferred("do_scene_change")

func do_scene_change() -> void:
	SceneManager.change_scene(home_village)
