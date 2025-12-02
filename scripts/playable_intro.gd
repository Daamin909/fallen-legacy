extends Node2D

const Balloon = preload("res://scenes/helpers/balloon/balloon.tscn")

@onready var master := $master
@onready var corruptor = $corruptor
@onready var master_anim = $master/AnimatedSprite2D
@onready var corruptor_anim = $"corruptor/Area2D/AnimatedSprite2D"
@export var dialogue_start: String = "start"

func _process(_delta: float) -> void:
	pass


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.name == "player_playable_intro":
		get_tree().change_scene_to_file("res://scenes/game_over.tscn")


func _ready() -> void:
	DialogueManager.dialogue_ended.connect(_on_dialogue_ended)
	var balloon: Node = Balloon.instantiate()
	get_parent().call_deferred("add_child", balloon)
	balloon.call_deferred("start", load("res://dialogues/playable_intro.dialogue"), dialogue_start)


func _on_dialogue_ended(_resource):

	await master.move_to(Vector2(6, 16))
	var balloon: Node = Balloon.instantiate()
	get_parent().call_deferred("add_child", balloon)
	await get_tree().create_timer(0.5	).timeout
	balloon.call_deferred("start", load("res://dialogues/playable_intro_confront.dialogue"), dialogue_start)
	DialogueManager.dialogue_ended.disconnect(_on_dialogue_ended)
	DialogueManager.dialogue_ended.connect(_on_confront_ended)
	#master.move_to(Vector2(70,200))



func _on_confront_ended(_resource):
	await master.move_to(Vector2(82,16))
	await get_tree().create_timer(0.5	).timeout
	corruptor_anim.play("attack")
	await get_tree().create_timer(0.7	).timeout
	master_anim.play("hurt")
	await get_tree().create_timer(0.7	).timeout
	#master_anim.play("hurt")
	#await get_tree().create_timer(0.7	).timeout
	#corruptor_anim.play("idle")
	#master_anim.play("attack")
