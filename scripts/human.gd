extends CharacterBody2D

const WALKING_SPEED = 60.0
const RUNNING_SPEED = 75.0

var direction = Vector2(randf_range(-1, 1), randf_range(-1, 1))
var old_direction
var new_direction
var speed
var t = 0.0
var state_chase = false
var zombie

func _ready():
	speed = WALKING_SPEED
	_on_walk_timer_timeout()
	pass


func _physics_process(_delta: float) -> void:
	if state_chase:
		new_direction = position - zombie.position + Vector2(randf_range(-0.3, 0.3), randf_range(-0.3, 0.3))
		new_direction = new_direction.normalized()
		direction = new_direction
	else:
		direction = old_direction.lerp(new_direction, t)
		if t < 1.0:
			t += 0.02
	
	velocity = direction * speed
	$AnimatedSprite2D.flip_h = direction.x < 0
	move_and_slide()


func _on_walk_timer_timeout() -> void:
	old_direction = direction
	new_direction = Vector2(randf_range(-1, 1), randf_range(-1, 1)).normalized()
	t = 0.0
	$WalkTimer.wait_time = randf_range(1, 4)


func _on_detection_range_body_entered(body: Node2D) -> void:
	if body.is_in_group("zombie"):
		zombie = body
		$WalkTimer.stop()
		state_chase = true
		speed = RUNNING_SPEED


func _on_detection_range_body_exited(body: Node2D) -> void:
	if body.is_in_group("zombie"):
		$WalkTimer.wait_time = randf_range(1, 4)
		$WalkTimer.start()
		speed = WALKING_SPEED
		state_chase = false
		
