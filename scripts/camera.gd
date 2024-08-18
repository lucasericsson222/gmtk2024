extends Camera2D

var fade_out_scene = preload("res://scenes/fade_to_black.tscn")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

var skip = false
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if skip:
		return
	var zombies = get_tree().get_nodes_in_group("zombie")
	if zombies.size() == 0:
		var outro_timer = Timer.new()
		outro_timer.wait_time = 2
		outro_timer.autostart = true
		get_parent().add_child(outro_timer)
		outro_timer.connect("timeout", _on_outro_timeout)
		skip = true
		
		var fade_out_instance: ColorRect = fade_out_scene.instantiate()
		fade_out_instance.position = Vector2.ZERO
		add_child(fade_out_instance)
		return
	
	var average_position = Vector2(0, 0)
	for z in zombies:
		average_position += z.position
	average_position /= zombies.size()
	self.position = average_position

func _on_outro_timeout():
	get_tree().change_scene_to_file("res://scenes/game_over.tscn")
