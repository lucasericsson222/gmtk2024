extends Control

func _on_main_menu_pressed() -> void:
	AudioManager.play_sfx(AudioManager.SoundEffects.MENU_BUTTON)
	Engine.time_scale = 1
	get_tree().change_scene_to_file("res://scenes/menu.tscn")
