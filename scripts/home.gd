extends Node2D

var home_village = "res://scenes/home_village.tscn"
@onready var player_sprite = $Player/AnimatedSprite2D
@onready var player = $Player
# Called when the node enters the scene tree for the first time.

func _ready():
	SceneManager.preload_scene(home_village)
	if SceneManager.is_player_position_inside_home_right:
		player_sprite.flip_h = true
		SceneManager.is_player_position_inside_home_right = false
	else:
		call_deferred("_set_initial_position")
	pass

func _process(_delta: float) -> void:
	pass


func _set_initial_position():
	player.position = Vector2(-280, -10)


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body is CharacterBody2D:
		SceneManager.change_scene(home_village)
