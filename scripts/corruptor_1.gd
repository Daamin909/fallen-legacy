extends CharacterBody2D
@onready var anim: Node2D = $AnimatedSprite2D

func _ready() -> void:
	_play_idle()
	
func _play_idle():
	anim.play("idle")
