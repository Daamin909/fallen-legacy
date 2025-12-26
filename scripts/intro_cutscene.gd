extends Node2D
@onready var sprity := $AnimatedSprite2D

func _ready() -> void:
	sprity.play("idle")
