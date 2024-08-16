extends CharacterBody2D

@onready var zombie_component = $ZombieComponent

func _physics_process(_delta: float) -> void:
	# Add the gravity.
	velocity = zombie_component.velocity
	move_and_slide()
