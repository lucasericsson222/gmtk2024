extends CharacterBody2D

const WALKING_SPEED = 60.0
const RUNNING_SPEED = 20.0

@onready var animated_sprite = $AnimatedSprite2D
var direction = Vector2(randf_range(-1, 1), randf_range(-1, 1))
var old_direction
var new_direction
var speed
var t = 0.0
var state_chase = false
var zombie
var dead = false

func _ready():
	speed = WALKING_SPEED
	_on_walk_timer_timeout()
	pass


func _physics_process(_delta: float) -> void:
	if state_chase:
		new_direction = position - zombie.position + Vector2(randf_range(-0.3, 0.3), randf_range(-0.3, 0.3))
		new_direction = new_direction.normalized()
		direction = new_direction
	elif dead:
		pass
	else:
		direction = old_direction.lerp(new_direction, t)
		if t < 1.0:
			t += 0.02
	
	velocity = direction * speed
	animated_sprite.flip_h = direction.x < 0
	move_and_slide()


func _on_walk_timer_timeout() -> void:
	old_direction = direction
	new_direction = Vector2(randf_range(-1, 1), randf_range(-1, 1)).normalized()
	t = 0.0
	$WalkTimer.wait_time = randf_range(1, 4)


func _on_run_timer_timeout() -> void:
	$WalkTimer.wait_time = randf_range(1, 4)
	$WalkTimer.start()
	state_chase = false
	speed = WALKING_SPEED
	animated_sprite.play("walk")
	$RunTimer.stop()


func _on_detection_range_body_entered(body: Node2D) -> void:
	zombie = body
	$WalkTimer.stop()
	state_chase = true
	speed = RUNNING_SPEED
	animated_sprite.play("run")


func _on_detection_range_body_exited(_body: Node2D) -> void:
	$RunTimer.wait_time = 3.5 + randf_range(-1, 1)
	$RunTimer.start()


func _on_human_killed() -> void:
	speed = 0.0
	state_chase = false
	dead = true
	get_node("DetectionRange").queue_free()
