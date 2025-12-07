extends Node2D

const Balloon = preload("res://scenes/helpers/balloon/balloon.tscn")

@onready var master := $master
@onready var corruptor = $corruptor
@onready var master_anim = $master/AnimatedSprite2D
@onready var corruptor_anim = $"corruptor/Area2D/AnimatedSprite2D"
@onready var attack_sound = $attack
@export var dialogue_start: String = "start"
@onready var cam: Camera2D = $Camera2D
@onready var death: AudioStreamPlayer2D = $death

@export var random_strength: float = 30.0
@export var shake_fade: float = 5.0

var rnd = RandomNumberGenerator.new()
var shake_strength: float = 0.0


func _shake_camera(strength: float):
	shake_strength = strength

func random_offset() -> Vector2:
	return Vector2(
		rnd.randf_range(-shake_strength, shake_strength),
		rnd.randf_range(-shake_strength, shake_strength)
	)

func _process(delta: float) -> void:
	if shake_strength > 0:
		shake_strength = lerpf(shake_strength, 0, shake_fade * delta)

	cam.offset = random_offset()

		
func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.name == "player_playable_intro":
		SceneManager.change_scene("res://scenes/game_over.tscn")


func _ready() -> void:
	rnd.randomize()
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
	
	# First Attack
	await get_tree().create_timer(0.5).timeout
	corruptor_anim.play("attack")
	await get_tree().create_timer(0.45).timeout
	attack_sound.play()	
	_shake_camera(5.0)
	await get_tree().create_timer(0.2).timeout
	master_anim.play("hurt")
	
	# Second Attack
	await get_tree().create_timer(0.3).timeout
	attack_sound.play()
	_shake_camera(5.0)
	master_anim.play("attack")
	corruptor_anim.play("idle")
	await get_tree().create_timer(0.2).timeout
	corruptor_anim.play("hurt")		
	
	# Third Attack
	await get_tree().create_timer(0.5	).timeout
	corruptor_anim.play("attack")
	master_anim.play("idle")
	await get_tree().create_timer(0.7	).timeout
	attack_sound.play()
	_shake_camera(5.0)
	master_anim.play("hurt")
	
	await get_tree().create_timer(0.7	).timeout
	attack_sound.play()
	master_anim.play("idle")
	corruptor_anim.play("attack")
	await get_tree().create_timer(0.7	).timeout
	_shake_camera(30.0)
	master_anim.play("death")
	death.play()
	spawn_master_ghosts()
	master.visible = false 
	corruptor_anim.play("idle")
	await get_tree().create_timer(0.7	).timeout
	_shake_camera(60.0)
	await get_tree().create_timer(0.7	).timeout
	_shake_camera(90.0)
	await get_tree().create_timer(0.7	).timeout
	_shake_camera(120.0)
	SceneManager.change_scene("res://scenes/home.tscn")

func spawn_master_ghosts() -> void:
	var target_positions = [
		Vector2(-153, 16),
		Vector2(85, -100),
		Vector2(85, 122)
	]

	for i in range(3):
		var g = master.duplicate(true)
		g.modulate = Color(1, 1, 1, 0.3)
		var sprite = g.get_node("AnimatedSprite2D")
		sprite.play("death")
		g.position = master.position
		get_parent().add_child(g)

		var tween = get_tree().create_tween()
		tween.tween_property(g, "position", target_positions[i], 2.0)
		tween.parallel().tween_property(g, "modulate:a", 0.0, 2.0)
		tween.finished.connect(func(): g.queue_free())
