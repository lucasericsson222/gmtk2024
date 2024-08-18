extends Area2D

@export var converted_scene_name: String = "res://scenes/zombie.tscn" 

@export var animated_sprite: AnimatedSprite2D
@export var immunity_timeout = 1.0
@export var blood_color: Color
@export var has_bloody_conversions = true
@export var number_of_conversions: float = 1
var spawn_offset_distance = 5

var dying = false
var just_converted = true

var blood_scene = preload("res://scenes/Blood.tscn")
var blue_cross = preload("res://scenes/blue_cross.tscn")

func _ready():
	animated_sprite.connect("animation_finished", _on_animated_sprite_2d_animation_finished)
	animated_sprite.connect("animation_looped", _on_animated_sprite_2d_animation_looped)
	var timer := Timer.new()
	add_child(timer)
	timer.wait_time = immunity_timeout
	timer.one_shot = true
	timer.start()
	timer.connect("timeout", _on_timer_timeout)
	
	if converted_scene_name == "res://scenes/zombie.tscn":
		var blue_cross_instance = blue_cross.instantiate()
		blue_cross_instance.position = Vector2(3, -10)
		add_child(blue_cross_instance)

func _on_timer_timeout():
	just_converted = false
	if converted_scene_name == "res://scenes/zombie.tscn":
		$BlueCross.queue_free()

func _on_body_entered(body: Node2D) -> void:
	_on_body_or_area_entered(body)

func _on_animated_sprite_2d_animation_finished() -> void:
	convert_entity()

func _on_animated_sprite_2d_animation_looped() -> void:
	convert_entity()

func convert_entity():
	if dying == true:
		var converted_scene: PackedScene = load(converted_scene_name)
		var center_position = get_parent().position
		for i in range(0, number_of_conversions):
			var offset = Vector2(1, 0).rotated(i * 360 / number_of_conversions) * spawn_offset_distance
			var converted_instance = converted_scene.instantiate()
			converted_instance.position = center_position + offset
			get_parent().get_parent().add_child(converted_instance)
		get_parent().queue_free()

func _on_body_or_area_entered(_body: Node2D) -> void:
	if just_converted:
		return
	animated_sprite.play("death")
	if has_bloody_conversions:
		var blood_instance: CPUParticles2D = blood_scene.instantiate()	
		blood_instance.color = blood_color
		
		get_parent().get_parent().add_child(blood_instance)
		blood_instance.position = get_parent().position
	get_node("CollisionShape2D").queue_free()
	dying = true


func _on_area_entered(area: Area2D) -> void:
	_on_body_or_area_entered(area)
