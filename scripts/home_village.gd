extends Node2D
const Balloon = preload("res://scenes/helpers/balloon/balloon.tscn")
var home = "res://scenes/home.tscn"
@export var dialogue_start: String = "start"
@onready var elder = $village_elder
@onready var elder_sprite = $village_elder/AnimatedSprite2D
@onready var player = $Player
@onready var player_sprite = $Player/AnimatedSprite2D
@onready var start_dialogue = $start_dialogue
@onready var start_dialogue2 = $start_dialogue2
var has_started_dialogue_once = false

func _ready():
	start_dialogue2.monitoring = false
	if SceneManager.graveyard_done:
		player.position = Vector2(4752, 30)
		elder.position = Vector2(3234, 21)
		elder_sprite.flip_h = !elder_sprite.flip_h
		start_dialogue.monitoring = false
		start_dialogue2.monitoring = true
	if SceneManager.post_arkblade_done:
		get_tree().queue_delete(elder)
	player.SPEED = 400.0
	elder_sprite.play("idle")
	var p = $AudioStreamPlayer2D
	p.stream.set_loop(true)
	p.play()

func _on_door_area_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		SceneManager.change_scene(home)


func _on_door_area_body_entered(_body: Node2D) -> void:
	PopupManager.show_popup("Click on the Door to Enter", 4.0, 270, Color("#00b9b6"))


func _on_start_dialogue_body_entered(body: Node2D) -> void:
	if not body is CharacterBody2D or has_started_dialogue_once:
		return
	has_started_dialogue_once = true
	player.set_physics_process(false)
	player_sprite.play("idle")
	
	DialogueManager.dialogue_ended.connect(_on_ts_ended)
	var balloon: Node = Balloon.instantiate()
	get_parent().call_deferred("add_child", balloon)
	balloon.call_deferred("start", load("res://dialogues/elder.dialogue"), dialogue_start)


func _on_ts_ended(_resource) -> void:
	SceneManager.preload_scene("res://scenes/graveyard.tscn")
	elder_sprite.flip_h = false
	elder.move_to(Vector2(454, 18))
	await get_tree().create_timer(3).timeout
	elder.queue_free()
	player.set_physics_process(true)
	PopupManager.show_popup("Quest Added: Talk to your inner voice", 4, 375)
	DialogueManager.dialogue_ended.disconnect(_on_ts_ended)


func _on_area_2d_body_entered(body: Node2D) -> void:
	if not body is CharacterBody2D:
		return
	SceneManager.change_scene("res://scenes/graveyard.tscn")


func _on_start_dialogue_2_body_entered(body: Node2D) -> void:
	if not body is CharacterBody2D :
		return
	if SceneManager.post_arkblade_done:
		return
	SceneManager.post_arkblade_done = true
	player.set_physics_process(false)
	player_sprite.play("idle")
	
	DialogueManager.dialogue_ended.connect(_on_baka_ended)
	var balloon: Node = Balloon.instantiate()
	get_parent().call_deferred("add_child", balloon)
	balloon.call_deferred("start", load("res://dialogues/elder_post_arkblade.dialogue"), dialogue_start)
	
func _on_baka_ended(_resource) -> void:
	elder_sprite.flip_h = false
	elder.move_to(Vector2(2600, 18))
	await get_tree().create_timer(3).timeout
	elder.queue_free()
	player.set_physics_process(true)
	PopupManager.show_popup("Quest Added: Go to the abandoned village.", 4, 410)
	DialogueManager.dialogue_ended.disconnect(_on_baka_ended)
	start_dialogue2.monitoring = false
