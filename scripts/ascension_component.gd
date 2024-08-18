extends Area2D

@export var ascended_scene_name: String = "res://scenes/super_zombie.tscn" 
@export var zombie_root_node: Node2D
@export var required_count = 5
var count = 0


func _on_body_entered(body: Node2D) -> void:
	if body.has_method("ascend"):
		count += 1
	
	if count >= required_count:
		var zombies = get_overlapping_bodies()
		
		var inner_count = 0
		for zombie in zombies:
			if zombie.has_method("ascend"):
				inner_count += 1
		
		if inner_count >= required_count:
			_on_ascend(zombies)
			get_parent().state = get_parent().ASCENDING

func _on_ascend(zombies: Array[Node2D]):
	var super_zombie_scene: PackedScene = load(ascended_scene_name)
	var super_zombie_instance = super_zombie_scene.instantiate()
	
	var sum_position = Vector2.ZERO
	for i in range(0, required_count):
		sum_position += zombies[i].position
	var avg_position = sum_position / required_count
		
	for zombie in zombies:
		if zombie.state == zombie.ASCENDING:
			return
	
	super_zombie_instance.position = avg_position
		
	zombie_root_node.get_parent().add_child(super_zombie_instance)
	
	count = 0 
	for current_zombie in zombies:
		if !current_zombie.has_method("ascend"):
			continue
		
		if count >= required_count:
			current_zombie.cancel_ascend()
			continue
		count += 1
		if current_zombie.get_instance_id() == get_parent().get_instance_id():
			continue
		current_zombie.queue_free()
	zombie_root_node.queue_free()

func _on_body_exited(body: Node2D) -> void:
	if body.has_method("ascend"):
		count -= 1
	#print(count)
