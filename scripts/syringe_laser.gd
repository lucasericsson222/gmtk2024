extends Area2D

@export var is_flipped = false 

func _on_animated_sprite_2d_animation_finished() -> void:
	queue_free()

func _ready():
	$AnimatedSprite2D.flip_h = is_flipped
	if is_flipped:
		$CollisionPolygon2D.scale *= -1 
	
