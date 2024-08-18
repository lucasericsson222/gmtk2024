extends RigidBody2D

@onready var push_area: Area2D = $Area2D
var push_speed = 200

func _integrate_forces(state: PhysicsDirectBodyState2D) -> void:
	var direction = Vector2.ZERO
	for body in push_area.get_overlapping_bodies():
		direction += (body.position - position).normalized()

	state.apply_central_force(-direction.normalized() * push_speed)
