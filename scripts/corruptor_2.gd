extends CharacterBody2D
class_name Enemy


@export var speed := 120
@export var attack_range := 40
@export var damage := 10
@onready var anim = $AnimatedSprite2D
@onready var detector = $PlayerDetector

signal health_changed(current: int, max: int)
signal died


@export var max_health := 200
var health := max_health
var is_dead := false

func take_damage(amount: int, knockback := Vector2.ZERO):
	if is_dead:
		return
	anim.play("hurt")
	health -= amount
	velocity += knockback
	emit_signal("health_changed", health, max_health)

	if health <= 0:
		die()

func die():
	is_dead = true
	emit_signal("died")
	queue_free()
	
var player: CharacterBody2D = null
var is_attacking := false

func _on_player_detector_body_entered(body):
	if body.name == "Player":
		player = body

func _on_player_detector_body_exited(body):
	if body == player:
		player = null

func _physics_process(delta):
	if is_dead:
		return

	if not is_on_floor():
		velocity += get_gravity() * delta

	if player and not is_attacking:
		var dx = player.global_position.x - global_position.x
		anim.flip_h = dx < 0

		if abs(dx) > attack_range:
			velocity.x = sign(dx) * speed
			anim.play("run")
		else:
			velocity.x = 0
			start_attack()
	else:
		velocity.x = move_toward(velocity.x, 0, speed)
		anim.play("idle")

	move_and_slide()
	
func start_attack():
	is_attacking = true
	anim.play("attack")
