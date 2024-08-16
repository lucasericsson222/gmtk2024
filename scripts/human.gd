extends CharacterBody2D

const WALKING_SPEED = 50.0
const RUNNING_SPEED = 70.0

var direction = Vector2(randf_range(-1, 1), randf_range(-1, 1))
var old_direction
var new_direction
var speed
var t = 0.0

func _ready():
	speed = WALKING_SPEED
	_on_timer_timeout()
	pass

func _physics_process(_delta: float) -> void:
	direction = old_direction.lerp(new_direction, t)
	velocity = direction * speed
	if t < 1.0:
		t += 0.02
	move_and_slide()

func _on_timer_timeout():
	old_direction = direction
	new_direction = Vector2(randf_range(-1, 1), randf_range(-1, 1)).normalized()
	t = 0.0
	$Timer.wait_time = randf_range(1, 4)


func _on_detection_range_body_entered(body: Node2D) -> void:
	if body.is_in_group("zombie"):
		$Timer.stop()
		new_direction = position - body.position + Vector2(randf_range(-0.3, 0.3), randf_range(-0.3, 0.3))
		new_direction = new_direction.normalized()
		speed = RUNNING_SPEED


func _on_detection_range_body_exited(body: Node2D) -> void:
	if body.is_in_group("zombie"):
		$Timer.wait_time = randf_range(1, 4)
		$Timer.start()
		speed = WALKING_SPEED
