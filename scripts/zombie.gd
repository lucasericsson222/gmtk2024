extends CharacterBody2D

@onready var zombie_component = $ZombieComponent
enum {NORMAL, ASCENDING, DYING}
var state = NORMAL
var max_id = 0

var can_ascend = false

func _physics_process(_delta: float) -> void:
	# Add the gravity.

	velocity = zombie_component.velocity
	if $AnimatedSprite2D.animation == "death":
		velocity = Vector2.ZERO

	$AnimatedSprite2D.flip_h = velocity.x < 0
	
	if state == ASCENDING:
		return
	move_and_slide()

func ascend():
	state = ASCENDING

func cancel_ascend():
	state = NORMAL

func _on_ascension_timer_timeout() -> void:
	can_ascend = true
