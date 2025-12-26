extends CharacterBody2D
class_name Enemy

enum State { IDLE, CHASE, ATTACK, HURT, DEAD }
var state: State = State.IDLE

@export var speed := 120
@export var attack_range := 40
@export var damage := 1
@export var max_health := 20
var has_hit := false

@onready var anim: AnimatedSprite2D = $AnimatedSprite2D
@onready var detector = $PlayerDetector

signal health_changed(current: int, max: int)
signal died

var health := max_health
var player: CharacterBody2D
var gravity: float = ProjectSettings.get_setting("physics/2d/default_gravity")

# -------------------------------------------------

func try_hit_player():
	if not player:
		return

	if anim.animation == "attack" and anim.frame == 3 and not has_hit:
		has_hit = true
		PlayerData.take_damage(damage)

func _physics_process(delta):
	if state == State.DEAD:
		return

	apply_gravity(delta)

	match state:
		State.IDLE:
			handle_idle()
		State.CHASE:
			handle_chase()
		State.ATTACK:
			handle_attack()
			try_hit_player()
		State.HURT:
			handle_hurt()

	move_and_slide()

# -------------------------------------------------
# STATES
# -------------------------------------------------

func handle_idle():
	anim.play("idle")
	velocity.x = move_toward(velocity.x, 0, speed)

	if player:
		state = State.CHASE

func handle_chase():
	if not player:
		state = State.IDLE
		return

	var dx = player.global_position.x - global_position.x
	anim.flip_h = dx < 0

	if abs(dx) <= attack_range:
		state = State.ATTACK
		return

	anim.play("run")
	velocity.x = sign(dx) * speed

func handle_attack():
	velocity.x = 0

	if anim.animation != "attack":
		has_hit = false
		anim.play("attack")


func handle_hurt():
	velocity.x = move_toward(velocity.x, 0, speed)

# -------------------------------------------------
# DAMAGE / DEATH
# -------------------------------------------------

func take_damage(amount: int, knockback := Vector2.ZERO):
	if state == State.DEAD:
		return

	health -= amount
	velocity += knockback
	state = State.HURT
	anim.play("hurt")
	emit_signal("health_changed", health, max_health)

	if health <= 0:
		die()

func die():
	state = State.DEAD
	velocity = Vector2.ZERO
	anim.play("death")
	emit_signal("died")

	var health_bar = get_parent().get_node("EnemyHealthUI")
	get_tree().queue_delete(health_bar)
	var sword_area = get_parent().get_node("SwordArea")
	var sword = get_parent().get_node("SwordArea/Sword")
	sword_area.visible = true
	sword.visible = true
	sword_area.monitoring = true


# -------------------------------------------------
# SIGNALS
# -------------------------------------------------

func _on_player_detector_body_entered(body):
	if body.name == "Player":
		player = body
		state = State.CHASE

func _on_player_detector_body_exited(body):
	if body == player:
		player = null
		state = State.IDLE

func _on_animated_sprite_2d_animation_finished():
	match state:
		State.ATTACK:
			state = State.CHASE
		State.HURT:
			state = State.CHASE
		State.DEAD:
			queue_free()


# -------------------------------------------------
# UTILS
# -------------------------------------------------

func apply_gravity(delta):
	if not is_on_floor():
		velocity.y += gravity * delta
