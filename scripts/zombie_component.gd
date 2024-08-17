extends Node

@export var velocity: Vector2 = Vector2.ZERO
@export var speed: float = 50 
var max_speed: float = 90
const ATTRACTION_SPEED: float = 0.025
const SEPARATION_SPEED: float = 50
const SEPARATION_MIN_DISTANCE: float = 12.25

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	max_speed += randf_range(-10, 10)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(_delta: float) -> void:
	
	var input_force = Vector2.ZERO
	if Input.is_action_pressed("left"):
		input_force += Vector2(-1, 0)
	if Input.is_action_pressed("right"):
		input_force += Vector2(1, 0)
	if Input.is_action_pressed("up"):
		input_force += Vector2(0, -1)
	if Input.is_action_pressed("down"):
		input_force += Vector2(0, 1)


	var zombies = get_tree().get_nodes_in_group("zombie")
	var zombie_count = zombies.size()
	var zombie_sum_position = Vector2.ZERO
	for zombie: Node2D in zombies:
		zombie_sum_position += zombie.position

	assert(zombie_count > 0)
	var zombie_average_position = zombie_sum_position / zombie_count

	var displacement_from_center: Vector2 = zombie_average_position - get_parent().position
	if (displacement_from_center.length() > 25):
		velocity += displacement_from_center * ATTRACTION_SPEED
	
	input_force.normalized()
	velocity += input_force * displacement_from_center.length()

	for zombie: Node2D in zombies:
		var clumping: Vector2 = zombie.position - get_parent().position
		if clumping.length() < SEPARATION_MIN_DISTANCE:
			velocity += (SEPARATION_MIN_DISTANCE - clumping.length()) * -1 * clumping.normalized() * SEPARATION_SPEED
	
	if velocity.length() < 5:
		velocity = Vector2.ZERO
	velocity = velocity.normalized() * clamp(velocity.length(), 20, max_speed)
	velocity /= 1.1
