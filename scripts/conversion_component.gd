extends Area2D

signal human_killed

@export var converted_scene = preload("res://scenes/zombie.tscn")

@export var animated_sprite: AnimatedSprite2D

func _ready():
	animated_sprite.connect("animation_finished", _on_animated_sprite_2d_animation_finished)

var dying = false

func _on_body_entered(body: Node2D) -> void:
	_on_body_or_area_entered(body)

func _on_animated_sprite_2d_animation_finished() -> void:
	if dying == true:
		var converted_instance = converted_scene.instantiate()
		get_parent().get_parent().add_child(converted_instance)
		converted_instance.position = get_parent().position
		get_parent().queue_free()

func _on_body_or_area_entered(_body: Node2D) -> void:
	animated_sprite.play("death")
	get_node("CollisionShape2D").queue_free()
	human_killed.emit()
	dying = true


func _on_area_entered(area: Area2D) -> void:
	_on_body_or_area_entered(area)
