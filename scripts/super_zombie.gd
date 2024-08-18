extends CharacterBody2D

@onready var zombie_component = $ZombieComponent
enum {NORMAL, ASCENDING, DYING, THROWING}
var state = NORMAL

var grab_for_throw_dist = 16

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("throw"):
		state = THROWING

var target = null

func _draw() -> void:
	# enable queue_redraw() in physics_process and uncomment to see
	#if target != null:
		#draw_line(Vector2.ZERO, target.position - position, Color.WHITE, 1)
	pass
	
func _physics_process(_delta: float) -> void:
	#queue_redraw()
	# Add the gravity.
	if state == NORMAL:
		velocity = zombie_component.velocity
	if state == THROWING:
		var zombies = get_tree().get_nodes_in_group("throwable_zombie")
		if target == null:
			if zombies.size() > 0:
				$ThrowTimer.start()
				var closest = zombies[0]
				var min_dist = INF
				for zombie: Node2D in zombies:
					if zombie.get_instance_id() == get_instance_id():
						continue
					var dist = (zombie.position - position).length()
					if dist < min_dist:
						closest = zombie
						min_dist = dist
				target = closest
		else:
			velocity = zombie_component.max_speed * (target.position - position).normalized()
		
			var dist = (target.position - position).length()
			if dist < grab_for_throw_dist:
				target.be_thrown((get_global_mouse_position() - position).angle())
				state = NORMAL
				target = null
			
	if $AnimatedSprite2D.animation == "death":
		velocity = Vector2.ZERO

	$AnimatedSprite2D.flip_h = velocity.x < 0
	
	if state == ASCENDING:
		return
	move_and_slide()

func _on_throw_timer_timeout() -> void:
	state = NORMAL
