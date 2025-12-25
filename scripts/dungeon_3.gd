extends Node2D

@onready var player := $Player

func _ready() -> void:
	pass

func _process(_delta: float) -> void:
	pass

func _on_void_body_entered(body: Node2D) -> void:
	if body is CharacterBody2D:
		player.position = Vector2(57, 176)
		PlayerData.take_damage(1)
