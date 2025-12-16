extends CharacterBody2D

const SPEED = 150.0
const GRAVITY = 900.0

var direction := 1  
var walk_time := 2.0
var idle_time := 1.0
var timer := 0.0
var state := "walk"

@onready var anim = $AnimatedSprite2D

func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity.y += GRAVITY * delta

	timer -= delta
	
	match state:
		"walk":
			velocity.x = direction * SPEED
			anim.play("walk")
			
			$AnimatedSprite2D.flip_h = direction == -1
			
			if timer <= 0:
				state = "idle"
				timer = idle_time
				velocity.x = 0

		"idle":
			anim.play("idle")
			velocity.x = 0
			
			if timer <= 0:
				direction *= -1
				state = "walk"
				timer = walk_time

	move_and_slide()
