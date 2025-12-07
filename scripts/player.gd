extends CharacterBody2D

const SPEED = 250.0
const JUMP_VELOCITY = -300.0
const MAX_JUMPS = 2   # normal + double jump

@onready var anim = $AnimatedSprite2D
@onready var run_sfx = $RunSFX
@onready var actionable_finder = $ActionableFinder



var jumps_left = MAX_JUMPS


func _physics_process(delta: float) -> void:
	if Input.is_action_just_pressed("ui_t"):
		var actionables = actionable_finder.get_overlapping_areas()
		if actionables.size() > 0:
			actionables[0].action()
		
	
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Reset jumps on landing
	if is_on_floor():
		jumps_left = MAX_JUMPS

	# Jumping (double jump included)
	if Input.is_action_just_pressed("ui_accept") and jumps_left > 0:
		velocity.y = JUMP_VELOCITY
		jumps_left -= 1

	# Movement
	var direction := Input.get_axis("ui_left", "ui_right")

	if direction != 0:
		velocity.x = direction * SPEED
		anim.flip_h = direction < 0

		if not run_sfx.playing and is_on_floor():
			run_sfx.play()

		if anim.animation != "run" and is_on_floor():
			anim.play("run")
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		if run_sfx.playing:
			run_sfx.stop()
		if is_on_floor() and anim.animation != "idle":
			anim.play("idle")

	# Air animations + stop run sfx in air
	if not is_on_floor():
		if run_sfx.playing:
			run_sfx.stop()

		if velocity.y < 0:
			anim.play("jump")
		else:
			anim.play("fall")

	move_and_slide()

func _ready():
	var p = $normal_bg_music
	p.stream.set_loop(true)
	p.play()
