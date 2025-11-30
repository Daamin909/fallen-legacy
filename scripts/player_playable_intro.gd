extends CharacterBody2D

const SPEED = 250.0
const JUMP_VELOCITY = -250.0

@onready var anim = $AnimatedSprite2D

func _physics_process(delta: float) -> void:
	# Gravity
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Jump
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Movement
	var direction := Input.get_axis("ui_left", "ui_right")

	if direction != 0:
		velocity.x = direction * SPEED

		anim.flip_h = direction < 0

		# RUN
		if anim.animation != "run":
			anim.play("run")
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

		# IDLE (only when not moving)
		if is_on_floor():
			if anim.animation != "idle":
				anim.play("idle")

	# Jump / fall
	if not is_on_floor():
		if velocity.y < 0:
			anim.play("jump")
		else:
			anim.play("fall")

	move_and_slide()
