extends Node2D
const Balloon = preload("res://scenes/helpers/balloon/balloon.tscn")
@export var dialogue_start: String = "start"
@onready var player := $Player
@onready var player_sprite := $Player/AnimatedSprite2D
@onready var master := $master

var soul: Node2D

func _ready() -> void:
	master.visible = false
	pass # Replace with function body.

func _process(_delta: float) -> void:
	pass
	
func _on_detect_body_entered(body: Node2D) -> void:
	if body is CharacterBody2D:
		_do_thingy()
 
func _do_thingy() -> void:
	DialogueManager.dialogue_ended.connect(_on_end)
	player_sprite.play("idle")
	player.set_physics_process(false)
	var balloon: Node = Balloon.instantiate()
	get_parent().call_deferred("add_child", balloon)
	balloon.call_deferred("start", load("res://dialogues/arkblade_reveal_soul.dialogue"), dialogue_start)
	spawn_soul()
	
func spawn_soul() -> void:
	soul = master.duplicate(true)
	soul.modulate = Color(1, 1, 1, 0.3)
	var sprite := soul.get_node("AnimatedSprite2D") as AnimatedSprite2D
	sprite.play("death")
	soul.position = master.position
	soul.visible = true
	get_parent().call_deferred("add_child", soul)
	master.call_deferred("queue_free")

func _on_end(_resource) -> void:
	get_tree().queue_delete(soul)
	PopupManager.show_popup("Quest Added: Find the ArkBlade", 4, 305)
	player.set_physics_process(true)
	DialogueManager.dialogue_ended.disconnect(_on_end)

func _on_detect_end_body_entered(body: Node2D) -> void:
	if body is CharacterBody2D:
		SceneManager.change_scene("res://scenes/dungeon_1.tscn")
