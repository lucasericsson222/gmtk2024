extends Area2D

signal zombie_killed 

@onready var animated_sprite: AnimatedSprite2D = $"../AnimatedSprite2D"
var new_zombie = preload("res://scenes/zombie.tscn")

@export var animated_sprite_2d: AnimatedSprite2D

func _ready():
	animated_sprite_2d.connect("animation_finished", _on_animated_sprite_2d_animation_finished)

var dying = false

func _on_body_entered(_body: Node2D) -> void:
	animated_sprite.play("death")
	get_node("CollisionShape2D").queue_free()
	zombie_killed.emit()
	dying = true

func _on_animated_sprite_2d_animation_finished() -> void:
	if dying == true:
		var zom_instance = new_zombie.instantiate()
		get_parent().get_parent().add_child(zom_instance)
		zom_instance.position = get_parent().position
		get_parent().queue_free()
