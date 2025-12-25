extends CanvasLayer

@onready var bar: ProgressBar = $ProgressBar

var current_enemy: Enemy = null

func _ready():
	add_to_group("enemy_ui")

func show_enemy(enemy: Enemy):

	if current_enemy:
		disconnect_enemy()

	current_enemy = enemy
	bar.max_value = enemy.max_health
	bar.value = enemy.health
	bar.visible = true

	enemy.health_changed.connect(_on_health_changed)
	enemy.died.connect(_on_enemy_died)


func disconnect_enemy():
	if not current_enemy:
		return

	if current_enemy.health_changed.is_connected(_on_health_changed):
		current_enemy.health_changed.disconnect(_on_health_changed)

	if current_enemy.died.is_connected(_on_enemy_died):
		current_enemy.died.disconnect(_on_enemy_died)

	current_enemy = null
	bar.visible = false

func _on_health_changed(current: int, max: int):
	print("UI received health:", current, "/", max)
	bar.max_value = max
	bar.value = max(current, 0)

func _on_enemy_died():
	disconnect_enemy()
