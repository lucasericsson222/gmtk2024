extends CharacterBody2D

enum {RUNNING, ATTACKING}

var state = RUNNING
var speed = 200
var max_speed: float = 75
var position_fix_speed: float = 8 

var target: Node2D = null

func _physics_process(_delta: float) -> void:
	if target == null:
		pass
	else:
		var displacement = (target.position - position)

		$AnimatedSprite2D.flip_h = displacement.x < 0

		if displacement.length() > 6 * 16:
			velocity += position_fix_speed * displacement.normalized()
		if displacement.length() < 6 * 16:
			velocity += position_fix_speed * -displacement.normalized()

	velocity /= 1.1

	velocity = clamp(velocity.length(), 0, max_speed) * velocity.normalized()
	
	move_and_slide()



func _on_area_2d_body_exited(_body:Node2D) -> void:
	var other_zombies = $Area2D.get_overlapping_bodies()
	if other_zombies.size() > 0:
		target = other_zombies[0]
	else:
		target = null

func _on_area_2d_body_entered(body:Node2D) -> void:
	
	target = body
