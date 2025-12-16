extends Node2D

var home_village = "res://scenes/home_village.tscn"
@onready var player_sprite = $Player/AnimatedSprite2D
@onready var player = $Player
const Balloon = preload("res://scenes/helpers/balloon/balloon.tscn")
@export var dialogue_start: String = "start"



func _ready():
	if SceneManager.is_player_position_inside_home_right:
		player.set_physics_process(false)
		player_sprite.flip_h = true
		SceneManager.is_player_position_inside_home_right = false
		_do_another_thingy()
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
	#DialogueManager.dialogue_ended.connect(_on_dialogue_ended)
	var balloon: Node = Balloon.instantiate()
	get_parent().call_deferred("add_child", balloon)
	balloon.call_deferred("start", load("res://dialogues/faint.dialogue"), dialogue_start)
