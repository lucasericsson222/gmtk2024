extends AnimatedSprite2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_area_2d_body_entered(body: Node2D) -> void:
	
	if body.is_in_group("throwable_zombie"):
		return
	animation = "broken"
	AudioManager.play_sfx(AudioManager.SoundEffects.TABLE_BREAK)
	$Area2D/CollisionShape2D.set_deferred("disabled", true)
	$StaticBody2D/CollisionShape2D.set_deferred("disabled", true)
