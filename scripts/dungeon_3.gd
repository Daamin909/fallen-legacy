extends Node2D

@onready var player := $Player
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#PlayerData.take_damage(9) # Replace with function body.
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_void_body_entered(body: Node2D) -> void:
	if body is CharacterBody2D:
		player.position = Vector2(57, 176)
		PlayerData.take_damage(1)
		
