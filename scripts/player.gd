extends CharacterBody2D

const SPEED = 250.0
const JUMP_VELOCITY = -300.0

@onready var anim = $AnimatedSprite2D
@onready var run_sfx = $RunSFX

func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity += get_gravity() * delta

	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	var direction := Input.get_axis("ui_left", "ui_right")

	if direction != 0:
		velocity.x = direction * SPEED
		anim.flip_h = direction < 0

		# start sound if not already playing
		if not run_sfx.playing:
			run_sfx.play()

		if anim.animation != "run":
			anim.play("run")
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

		# stop sound if moving stops
		if run_sfx.playing:
			run_sfx.stop()

		if is_on_floor() and anim.animation != "idle":
			anim.play("idle")

	if not is_on_floor():
		# stop running sound when off ground
		if run_sfx.playing:
			run_sfx.stop()

		if velocity.y < 0:
			anim.play("jump")
		else:
			anim.play("fall")

	move_and_slide()
