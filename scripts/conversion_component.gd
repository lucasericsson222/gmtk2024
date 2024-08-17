extends Area2D

signal human_killed

@export var converted_scene = load("res://scenes/zombie.tscn")

@export var animated_sprite: AnimatedSprite2D

var dying = false
var just_converted = true

func _ready():
	animated_sprite.connect("animation_finished", _on_animated_sprite_2d_animation_finished)
	var timer := Timer.new()
	add_child(timer)
	timer.wait_time = 1
	timer.one_shot = true
	timer.start()
	timer.connect("timeout", _on_timer_timeout)

func _on_timer_timeout():
	just_converted = false

func _on_body_entered(body: Node2D) -> void:
	_on_body_or_area_entered(body)

func _on_animated_sprite_2d_animation_finished() -> void:
	if dying == true:
		var converted_instance = converted_scene.instantiate()
		converted_instance.position = get_parent().position
		get_parent().get_parent().add_child(converted_instance)
		get_parent().queue_free()

func _on_body_or_area_entered(_body: Node2D) -> void:
	if just_converted:
		return
	animated_sprite.play("death")
	get_node("CollisionShape2D").queue_free()
	human_killed.emit()
	dying = true


func _on_area_entered(area: Area2D) -> void:
	_on_body_or_area_entered(area)
