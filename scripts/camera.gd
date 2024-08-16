extends Camera2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var zombies = get_tree().get_nodes_in_group("zombie")
	var average_position = Vector2(0, 0)
	for z in zombies:
		average_position += z.position
	average_position /= zombies.size()
	self.position = average_position
