extends CharacterBody2D

@onready var zombie_component = $ZombieComponent

func _physics_process(_delta: float) -> void:
	# Add the gravity.
	velocity = zombie_component.velocity

	$AnimatedSprite2D.flip_h = velocity.x < 0

	move_and_slide()
