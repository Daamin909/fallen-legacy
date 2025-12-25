extends Node

var max_health := 10
var health := 10

signal health_changed(current, max)
signal died

func take_damage(amount: int):
	health = clamp(health - amount, 0, max_health)
	emit_signal("health_changed", health, max_health)
	if health == 0:
		emit_signal("died")

func heal(amount: int):
	health = clamp(health + amount, 0, max_health)
	emit_signal("health_changed", health, max_health)

func reset():
	health = max_health
	emit_signal("health_changed", health, max_health)
