extends Node2D

@onready var player := $Player
@onready var player_sprite := $Player/AnimatedSprite2D
@onready var sword_area := $SwordArea
@onready var camera = $Player/Camera2D
@onready var sword = $SwordArea/Sword
@onready var health_bar = $EnemyHealthUI
@onready var master := $master
const Balloon = preload("res://scenes/helpers/balloon/balloon.tscn")
var soul: Node2D


var been_there = false
var finalissima = false

func _ready() -> void:
	master.visible = false
	sword_area.monitoring = false
func _process(_delta: float) -> void:
	pass

func _on_void_body_entered(body: Node2D) -> void:
	if body is CharacterBody2D:
		player.position = Vector2(57, 176)
		PlayerData.take_damage(1)


func _on_sword_area_body_entered(_body: Node2D) -> void:
	if been_there:
		return
	been_there = true
	player.set_physics_process(false)
	player.position = Vector2(575, 179)
	camera.zoom = Vector2(5, 5)
	camera.position = Vector2(0, -40)
	sword.position = Vector2(0, -30)
	player_sprite.play("idle")
	
	
	await get_tree().create_timer(2).timeout
	PopupManager.show_popup("Quest Completed: ARKBLADE ACQUIRED!!!", 5, 370)
	
	await get_tree().create_timer(1).timeout
	get_tree().queue_delete(sword_area)
	player.set_physics_process(true)
	camera.position = Vector2(6, -93)
	camera.zoom = Vector2(2.1, 2.1)


func _on_end_dialogue_body_entered(body: Node2D) -> void:
	if not been_there:
		return
	if finalissima:
		return
	if body is CharacterBody2D:
		finalissima = true
		_do_thingy()

func _do_thingy() -> void:
	DialogueManager.dialogue_ended.connect(_on_end)
	player_sprite.play("idle")
	player.set_physics_process(false)
	var balloon: Node = Balloon.instantiate()
	get_parent().call_deferred("add_child", balloon)
	balloon.call_deferred("start", load("res://dialogues/arkblade_found.dialogue"), "start")
	spawn_soul()

func _on_end(_resource) -> void:
	get_tree().queue_delete(soul)
	PopupManager.show_popup("Quest Added: Find the Corruptor HQ", 4, 345)
	player.set_physics_process(true)
	DialogueManager.dialogue_ended.disconnect(_on_end)


func spawn_soul() -> void:
	soul = master.duplicate(true)
	soul.modulate = Color(1, 1, 1, 0.3)
	var sprite := soul.get_node("AnimatedSprite2D") as AnimatedSprite2D
	sprite.play("death")
	soul.position = master.position
	soul.visible = true
	get_parent().call_deferred("add_child", soul)
	master.call_deferred("queue_free")


func _on_change_scene_body_entered(body: Node2D) -> void:
	if body is CharacterBody2D:
		SceneManager.change_scene("res://scenes/dungeon_4.tscn")
