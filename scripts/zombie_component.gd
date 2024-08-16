extends Node

@export var velocity = Vector2.ZERO
@export var speed = 100 

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(_delta: float) -> void:
	velocity = Vector2.ZERO
	
	if Input.is_action_pressed("ui_left"):
		velocity += Vector2(-1, 0)
	if Input.is_action_pressed("ui_right"):
		velocity += Vector2(1, 0)
	if Input.is_action_pressed("ui_up"):
		velocity += Vector2(0, -1)
	if Input.is_action_pressed("ui_down"):
		velocity += Vector2(0, 1)

	velocity.normalized()

	var zombies = get_tree().get_nodes_in_group("zombie")
	var zombie_count = zombies.size()
	var zombie_sum_position = Vector2.ZERO
	for zombie: Node2D in zombies:
		zombie_sum_position += zombie.position

	assert(zombie_count > 0)
	var zombie_average_position = zombie_sum_position / zombie_count

	velocity *= speed
