extends CharacterBody2D

@onready var zombie_component = $ZombieComponent
enum {NORMAL, ASCENDING, DYING, THROWN}
var state = NORMAL
var max_id = 0

var thrown_speed = 200

var can_ascend = false
var z_throw_velocity = 2
var z_velocity = 0
var z_gravity = -5
var z_pos = 0

func _ready() -> void:
	if randi_range(0, 1) == 0:
		AudioManager.play_sfx(AudioManager.SoundEffects.ZOMBIE_GROAN_1)
	else:
		AudioManager.play_sfx(AudioManager.SoundEffects.ZOMBIE_GROAN_2)

func _physics_process(delta: float) -> void:
	# Add the gravity.
	
	if state == NORMAL:
		velocity = zombie_component.velocity
	if $AnimatedSprite2D.animation == "death":
		velocity = Vector2.ZERO
	if state == THROWN:
		z_velocity += z_gravity * delta
		z_pos += z_velocity
		if z_pos <= 0:
			z_pos = 0
			z_velocity = 0
			state = NORMAL
			$AnimatedSprite2D.animation = "default"
			var collision_shape = $ConversionComponent/CollisionShape2D
			if collision_shape != null:
				collision_shape.disabled = false
			set_collision_layer_value(1, true)


		$AnimatedSprite2D.position.y = -z_pos

	$AnimatedSprite2D.flip_h = velocity.x < 0
	
	if state == ASCENDING:
		return
	move_and_slide()
	
func be_thrown(dir: float):
	state = THROWN
	velocity = thrown_speed * Vector2.RIGHT.rotated(dir)
	$AnimatedSprite2D.animation = "thrown"
	z_velocity = z_throw_velocity
	var collision_shape = $ConversionComponent/CollisionShape2D
	if collision_shape != null:
		collision_shape.disabled = true
	set_collision_layer_value(1, false)

func ascend():
	state = ASCENDING

func cancel_ascend():
	state = NORMAL

func _on_ascension_timer_timeout() -> void:
	can_ascend = true
