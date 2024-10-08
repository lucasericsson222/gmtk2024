extends CharacterBody2D

enum {RUNNING, TRACKING, ATTACKING, SHOOTING}

var state = RUNNING
var max_speed: float = 60 
var position_fix_speed: float = 8 
var syringe_laser_scene = preload("res://scenes/syringe_laser.tscn")
var attacking_offset = 20
var fire_range = 20
var laser_length = 32
var attack_position_dif: Vector2 = Vector2.ZERO
var attack_decel_radius = 24
var doctor_see_distance = 100

var syringeIsFull = false 
var dead = false

var target: Node2D = null

func _draw() -> void:
	# debug drawing
	#if target != null:
	#	draw_line(Vector2.ZERO, target.position - position, Color.WHITE, 1)
	#if attack_position_dif != Vector2.ZERO:
	#	draw_line(Vector2.ZERO, attack_position_dif, Color.RED, 1)
	pass

func _process(_delta: float) -> void:
	queue_redraw()

func _physics_process(_delta: float) -> void:
	if state == SHOOTING:
		return
	if $AnimatedSprite2D.animation == "death":
		velocity = Vector2.ZERO
		dead = true
		move_and_slide()
		return

	track_nearest_zombie()
	if target == null or (target.position - position).length() > doctor_see_distance:
		attack_position_dif = Vector2.ZERO
	else:
		var displacement = (target.position - position)
		var facing = displacement.x < 0 # true if left
		$AnimatedSprite2D.flip_h = facing

		if state == TRACKING:
			attack_position_dif = Vector2.ZERO
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
				offset = Vector2(-attacking_offset, 0)
			else:
				offset = Vector2(attacking_offset, 0)

			attack_position_dif = (displacement - offset)
			
			velocity += position_fix_speed * 4 * attack_position_dif.normalized()
			if velocity.length() > 0 and displacement.length() < attack_decel_radius:
				velocity /= 1.5
			
			if displacement.length() < fire_range:
				$SyringeAttackDelayTimer.start()
				state = SHOOTING
				$AnimatedSprite2D.pause()
				

	velocity /= 1.1

	velocity = clamp(velocity.length(), 0, max_speed) * velocity.normalized()

	
	move_and_slide()



func _on_syringe_recharge_timer_timeout() -> void:
	if dead:
		return
	syringeIsFull = true
	$AnimatedSprite2D.animation = "default"

func track_nearest_zombie() -> void:
	var other_zombies = $ZombieDetectionRange.get_overlapping_bodies()
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
	var minvalue = (arr[0].position - position).length()
	for item in arr:
		var curvalue = item.position - position
		if curvalue.length() < minvalue:
			minvalue = curvalue.length()
			minitem = item
	return minitem


func _on_syringe_attack_delay_timer_timeout() -> void:
	if target == null:
		return
	if !is_instance_valid(target):
		target = null
		return
	var laser_instance = syringe_laser_scene.instantiate()
	var facing = $AnimatedSprite2D.flip_h
	laser_instance.is_flipped = facing
	var laser_offset
	if facing:
		laser_offset = Vector2(-laser_length/2.0, 0) # sprite is laser_length long, centered, so half of laser length uncenters 
	else:
		laser_offset = Vector2(laser_length/2.0, 0)
	laser_instance.position = laser_offset
	add_child(laser_instance)
	state = TRACKING
	syringeIsFull = false
	$SyringeRechargeTimer.start()
	$AnimatedSprite2D.animation = "empty"
	$AnimatedSprite2D.play()
