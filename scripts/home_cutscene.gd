extends Node2D

var dialogue_num := 1
var home_village = "res://scenes/home_village.tscn"
const Balloon = preload("res://scenes/helpers/balloon/balloon.tscn")
@onready var player_sprite = $Player/AnimatedSprite2D
@onready var player = $Player
@export var dialogue_start: String = "start"
@onready var doc := $doctor
@onready var doc_sprite := $doctor/AnimatedSprite2D
@onready var elder := $village_elder
@onready var elder_sprite := $village_elder/AnimatedSprite2D

func _ready():
	elder_sprite.play("idle")
	doc_sprite.play("idle")
	if SceneManager.is_player_position_inside_home_right:
		player.set_physics_process(false)
		player_sprite.flip_h = true
		player.rotation_degrees = 90
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

	
signal dialogue_finished

func _play_dialogue(path: String) -> void:
	var balloon := Balloon.instantiate()
	get_parent().call_deferred("add_child", balloon)
	await balloon.ready

	balloon.start(load(path), dialogue_start)


	if not DialogueManager.dialogue_ended.is_connected(_on_temp_dialogue_end):
		DialogueManager.dialogue_ended.connect(_on_temp_dialogue_end)

	balloon.start(load(path), dialogue_start)

	await self.dialogue_finished


func _on_temp_dialogue_end(_resource) -> void:
	DialogueManager.dialogue_ended.disconnect(_on_temp_dialogue_end)
	emit_signal("dialogue_finished")
