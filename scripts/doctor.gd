extends CharacterBody2D

enum {RUNNING, ATTACKING}

var state = RUNNING
var speed = 200
var max_speed = 200

var target: Node2D = null

func _physics_process(_delta: float) -> void:
	velocity = Vector2.ZERO

	if target == null:
		pass
	else:
		var displacement = (target.position - position)
		var direction_to_move = clamp(16*8 - displacement.length(), -max_speed, max_speed) * displacement.normalized()
		velocity += direction_to_move
	
	move_and_slide()



func _on_area_2d_body_exited(body:Node2D) -> void:
	var other_zombies = $Area2D.get_overlapping_bodies()
	if other_zombies.size() > 0:
		target = other_zombies[0]
	else:
		target = null

func _on_area_2d_body_entered(body:Node2D) -> void:
	target = body
