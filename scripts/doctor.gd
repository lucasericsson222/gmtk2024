extends CharacterBody2D

enum {RUNNING, TRACKING, ATTACKING}

var state = RUNNING
var speed = 200
var max_speed: float = 75
var position_fix_speed: float = 8 
var syringe_laser_scene = preload("res://scenes/syringe_laser.tscn")

var syringeIsFull = false 

var target: Node2D = null

func _physics_process(_delta: float) -> void:
	track_nearest_zombie()
	if target == null:
		pass
	else:
		var displacement = (target.position - position)
		var facing = displacement.x < 0 # true if left
		$AnimatedSprite2D.flip_h = facing

		if state == TRACKING:
			if displacement.length() > 6 * 16:
				velocity += position_fix_speed * displacement.normalized()
			if displacement.length() < 6 * 16:
				velocity += position_fix_speed * -displacement.normalized()
			if syringeIsFull:
				state = ATTACKING
		if state == ATTACKING:
			# idea here is that the doctor will only ever attack left or right,
			# so it will attempt to stand 
			var offset
			if facing: #left
				offset = Vector2(20, 0)
			else:
				offset = Vector2(-20, 0)
			
			velocity += position_fix_speed * (displacement - offset).normalized()
			if velocity.length() > 0 and (displacement - offset).length() < 16:
				velocity /= 1.5
			
			if (displacement-offset).length() < 64:
				var laser_instance = syringe_laser_scene.instantiate()
				laser_instance.is_flipped = facing
				var laser_offset
				if facing:
					laser_offset = Vector2(-16, 0)
				else:
					laser_offset = Vector2(16, 0)
				laser_instance.position = laser_offset
				add_child(laser_instance)
				state = TRACKING
				syringeIsFull = false
				$SyringeRechargeTimer.start()
				$AnimatedSprite2D.animation = "empty"
				

	velocity /= 1.1

	velocity = clamp(velocity.length(), 0, max_speed) * velocity.normalized()
	
	move_and_slide()

func _on_syringe_recharge_timer_timeout() -> void:
	syringeIsFull = true
	$AnimatedSprite2D.animation = "default"

func track_nearest_zombie() -> void:
	var other_zombies = $Area2D.get_overlapping_bodies()
	if other_zombies.size() > 0:
		state = TRACKING
		# take the next closest body
		target = array_min(other_zombies)
	else:
		state = RUNNING
		target = null

func array_min(arr: Array[Node2D]) -> Node2D:
	if arr.size() == 0:
		return null
	var minitem = arr[0]
	var minvalue = arr[0].position - position
	for item in arr:
		var curvalue = item.position - position
		if curvalue < minvalue:
			minvalue = curvalue
			minitem = item
	return minitem


func _on_area_2d_body_exited(_body: Node2D) -> void:
	track_nearest_zombie()

func _on_area_2d_body_entered(body: Node2D) -> void:
	if target != null:
		# if target is closer, don't switch targets
		if target.position.distance_squared_to(position) < body.position.distance_squared_to(position):
			return
	target = body
	state = TRACKING