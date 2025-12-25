extends Node2D

@onready var player:= $Player
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body is CharacterBody2D:
		SceneManager.change_scene("res://scenes/graveyard.tscn") # Replace with function body.


func _on_void_body_entered(body: Node2D) -> void:
	if body is CharacterBody2D:
		player.position = Vector2(-248, -887)
		PlayerData.take_damage(1) # Replace with function body.
