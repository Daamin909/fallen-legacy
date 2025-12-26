extends CharacterBody2D

@export var speed: float = 250.0
@export var jump_velocity: float = -250.0

@onready var anim: AnimatedSprite2D = $AnimatedSprite2D

var target_position: Vector2 = Vector2.ZERO
var moving: bool = false

func _ready() -> void:
	anim.play("idle")

func move_to(pos: Vector2) -> void:
	target_position = pos
	moving = true


func _physics_process(delta: float) -> void:
	var gravity: float = ProjectSettings.get_setting("physics/2d/default_gravity")
	if not is_on_floor():
		velocity.y += gravity * delta

	if not moving:
		move_and_slide()
		return

	var dx: float = target_position.x - global_position.x
	if abs(dx) <= 4.0:
		velocity.x = 0
		moving = false
		_play_idle()
		if is_on_floor():
			global_position.x = target_position.x
		move_and_slide()
		return

	var dir: float = sign(dx)
	anim.flip_h = dir < 0
	velocity.x = dir * speed
	_play_run()

	if is_on_floor() and should_jump(dir):
		velocity.y = jump_velocity

	move_and_slide()


func should_jump(dir: float) -> bool:
	var ss = get_world_2d().direct_space_state

	var ground_from = global_position + Vector2(dir * 10, 4)
	var ground_to = ground_from + Vector2(0, 28)
	var ground_query = PhysicsRayQueryParameters2D.create(ground_from, ground_to)
	ground_query.exclude = [self]
	var ground_hit = ss.intersect_ray(ground_query)
	if ground_hit == {}:
		return true

	var front_from = global_position + Vector2(dir * 10, -8)
	var front_to = front_from + Vector2(dir * 18, -8)
	var front_query = PhysicsRayQueryParameters2D.create(front_from, front_to)
	front_query.exclude = [self]
	var front_hit = ss.intersect_ray(front_query)
	if not front_hit == {}:
		return true
	
	return false

func _play_idle():
	if anim.animation != "idle":
		anim.play("idle")

func _play_run():
	if anim.animation != "run":
		anim.play("run")
