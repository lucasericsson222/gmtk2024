extends Area2D

@export var ascended_scene_name: String = "res://scenes/super_zombie.tscn" 

@export var required_count = 5
var count = 0

func _on_body_entered(_body: Node2D) -> void:
	count += 1
	#print(count)
	if count >= required_count:
		var zombies_to_ascend = get_overlapping_bodies()
		var ascended_instance = load(ascended_scene_name).instantiate()
		ascended_instance.position = get_parent().position
		get_parent().get_parent().add_child(ascended_instance)
		
		for z in zombies_to_ascend:
			z.queue_free()
		get_parent().queue_free()


func _on_body_exited(_body: Node2D) -> void:
	count -= 1
	#print(count)
