extends CharacterBody2D

const SPEED = 250.0
const JUMP_VELOCITY = -250.0

@onready var anim = $AnimatedSprite2D
@onready var master := get_parent().get_node("master")

func _physics_process(delta: float) -> void:
	# Gravity
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Jump
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		#DialogueManager.show_example_dialogue_balloon(load("res://dialogues/intro.dialogue"),"start")
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

@export var dialogue_start: String = "start"

const Balloon = preload("res://scenes/helpers/balloon/balloon.tscn")

func _ready() -> void:
	DialogueManager.dialogue_ended.connect(_on_dialogue_ended)

	var balloon: Node = Balloon.instantiate()
	get_parent().call_deferred("add_child", balloon)

	balloon.call_deferred("start", load("res://dialogues/playable_intro.dialogue"), dialogue_start)


func _on_dialogue_ended(_resource):
	
	await master.move_to(Vector2(6, 16))
	#master.move_to(Vector2(70,200))
