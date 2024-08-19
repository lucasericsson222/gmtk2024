extends Camera2D

var fade_out_scene = preload("res://scenes/fade_to_black.tscn")

var skip = false
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if skip:
		return
	var zombies = get_tree().get_nodes_in_group("camera")
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
	if (average_position - position).length() > 200:
		position_smoothing_enabled = false
	else:
		position_smoothing_enabled = true
	position = average_position
	#self.position = Vector2(floor(average_position.x), floor(average_position.y))
	

	

func _on_outro_timeout():
	get_tree().change_scene_to_file("res://scenes/game_over.tscn")
