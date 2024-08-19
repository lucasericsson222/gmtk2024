extends CharacterBody2D


const SPEED = 20

var zombie_scene = preload("res://scenes/zombie.tscn")
var dying = false

func _physics_process(delta: float) -> void:
	if dying:
		return
	# Add the gravity.
	var cheeses = get_tree().get_nodes_in_group("cheese")
	if cheeses.size() < 1:
		return
	var cheese = cheeses[0]
	
	if (cheese.position - position).length() < 10:
		cheese.queue_free()
		$AnimatedSprite2D.animation = "death"
		dying = true
	
	var dir = (cheese.position - position).normalized()
	velocity = dir * SPEED
	
	$AnimatedSprite2D.flip_h = velocity.x < 0
	
	move_and_slide()


func _on_animated_sprite_2d_animation_finished() -> void:
	print("HI")
	if dying:
		var zombie_instance = zombie_scene.instantiate()
		zombie_instance.position = position
		get_parent().add_child(zombie_instance)
		queue_free()
