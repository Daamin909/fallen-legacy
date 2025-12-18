extends Node2D

var home_village = "res://scenes/home_village.tscn"
@onready var player_sprite = $Player/AnimatedSprite2D
@onready var player = $Player


func _ready():
	if SceneManager.is_player_position_inside_home_right:
		player_sprite.flip_h = true
	else:
		call_deferred("_set_initial_position")
	pass

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


func _do_another_thingy() -> void:
	await _play_dialogue("res://dialogues/faint_1.dialogue")
	doc.move_to(Vector2(69, -16))
	await _play_dialogue("res://dialogues/faint_2.dialogue")
	player.set_physics_process(true)
	player.move_to(Vector2(130, -10))
	player.rotation_degrees = 0
	await _play_dialogue("res://dialogues/faint_3.dialogue")
	await _play_dialogue("res://dialogues/faint_4.dialogue")
	doc.move_to(Vector2(-181, -31))
	elder.move_to(Vector2(-181, -31))
	await get_tree().create_timer(0.75	).timeout
	player.move_to(Vector2(287, -60))
	await get_tree().create_timer(0.9	).timeout
	player.set_physics_process(false)
	player.position = Vector2(287, -75)
	player.rotation_degrees = 90
	player_sprite.flip_h = true
	SceneManager.change_scene("res://scenes/home.tscn")
	
