extends Node2D

@onready var player := $Player
@onready var player_sprite := $Player/AnimatedSprite2D
@onready var sword_area := $SwordArea
@onready var camera = $Player/Camera2D
@onready var sword = $SwordArea/Sword
@onready var health_bar = $EnemyHealthUI
var been_there = false

func _ready() -> void:
	sword_area.monitoring = false
func _process(_delta: float) -> void:
	pass

func _on_void_body_entered(body: Node2D) -> void:
	if body is CharacterBody2D:
		player.position = Vector2(57, 176)
		PlayerData.take_damage(1)


func _on_sword_area_body_entered(body: Node2D) -> void:
	if been_there:
		return
	been_there = true
	player.set_physics_process(false)
	player.position = Vector2(575, 179)
	camera.zoom = Vector2(5, 5)
	camera.position = Vector2(0, -40)
	sword.position = Vector2(0, -30)
	player_sprite.play("idle")
	
