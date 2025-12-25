extends CanvasLayer

@export var heart_full: Texture2D
@export var heart_empty: Texture2D
@export var health_per_heart := 1

@onready var hearts := $Hearts

func _ready():
	PlayerData.health_changed.connect(update_hearts)
	update_hearts(PlayerData.health, PlayerData.max_health)

func update_hearts(current: int, max: int):
	# Clear old hearts
	for child in hearts.get_children():
		child.queue_free()

	var max_hearts := int(ceil(float(max) / health_per_heart))
	var current_hearts := int(ceil(float(current) / health_per_heart))

	for i in max_hearts:
		var tex := heart_full if i < current_hearts else heart_empty
		var heart := TextureRect.new()
		heart.texture = tex
		heart.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT
		hearts.add_child(heart)
