extends CharacterBody2D

var SPEED = 250.0
const JUMP_VELOCITY = -300.0
const MAX_JUMPS = 2  

@onready var anim = $AnimatedSprite2D
@onready var run_sfx = $RunSFX
@onready var actionable_finder = $ActionableFinder
@onready var collision_shape = $CollisionShape2D

var is_attacking := false
var can_attack := true


var jumps_left = MAX_JUMPS


func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity += get_gravity() * delta

	if Input.is_action_just_pressed("attack") and can_attack:
		start_attack()
	
	if is_attacking:
		if wants_to_cancel_attack():
			cancel_attack()
		else:
			move_and_slide()
			return

	if Input.is_action_just_pressed("ui_t"):
		var actionables = actionable_finder.get_overlapping_areas()
		if actionables.size() > 0:
			actionables[0].action()

	if is_on_floor():
		jumps_left = MAX_JUMPS

	if Input.is_action_just_pressed("ui_accept") and jumps_left > 0:
		velocity.y = JUMP_VELOCITY
		jumps_left -= 1

	var direction := Input.get_axis("ui_left", "ui_right")

	if direction != 0:
		velocity.x = direction * SPEED
		anim.flip_h = direction < 0
		if is_on_floor():
			anim.play("run")
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		if run_sfx.playing:
			run_sfx.stop()
		if is_on_floor():
			anim.play("idle")


	if not is_on_floor():
		if velocity.y < 0:
			anim.play("jump")
		else:
			anim.play("fall")

	move_and_slide()

func cancel_attack():
	is_attacking = false
	can_attack = true
	if not is_on_floor():
		anim.play("jump" if velocity.y < 0 else "fall")
	else:
		anim.play("run" if Input.get_axis("ui_left", "ui_right") != 0 else "idle")


func start_attack():
	is_attacking = true
	can_attack = false
	velocity.x = 0   
	anim.play("attack")

func _on_animated_sprite_2d_animation_finished():
	if anim.animation == "attack" and is_attacking:
		is_attacking = false
		can_attack = true

func wants_to_cancel_attack() -> bool:
	return (
		Input.get_axis("ui_left", "ui_right") != 0
		or Input.is_action_just_pressed("ui_accept")
	)
