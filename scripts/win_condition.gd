extends Node2D
@export var threshold = 5
@export var big_zombie_points = 5
const SCALE_RATE = 0.1

var fade_out_scene = preload("res://scenes/fade_to_black.tscn")
var win = false
func _process(delta: float) -> void:
	var small_zombies = get_tree().get_nodes_in_group("small_zombie")
	var big_zombies = get_tree().get_nodes_in_group("big_zombie")
	
	var count = small_zombies.size() + big_zombies.size() * big_zombie_points
	if count > threshold:
		for zombie in get_tree().get_nodes_in_group("zombie"):
			var animated_sprite: AnimatedSprite2D = zombie.get_node("AnimatedSprite2D")
			animated_sprite.scale += 1 * delta * Vector2(1, 1)
			animated_sprite.z_index = 30
		if !win:
			$WinTimer.start()
			win = true

func _on_win_timer_timeout() -> void:
	var outro_timer = Timer.new()
	outro_timer.wait_time = 2
	outro_timer.autostart = true
	get_parent().add_child(outro_timer)
	outro_timer.connect("timeout", _on_outro_timeout)
		
	var fade_out_instance: ColorRect = fade_out_scene.instantiate()
	fade_out_instance.position = Vector2.ZERO
	var animation_player: AnimationPlayer = fade_out_instance.get_node("AnimationPlayer")
	animation_player.speed_scale = 1
	get_parent().get_node("Camera2D").add_child(fade_out_instance)
	get_parent().get_node("Camera2D").skip = true

func _on_outro_timeout():
	get_tree().change_scene_to_file("res://scenes/win.tscn")
