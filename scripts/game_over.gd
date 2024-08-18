extends Control


func _ready() -> void:
	AudioManager.play_song(AudioManager.Songs.GAME_OVER)
	
	if AudioServer.get_bus_effect_count(0) > 0:
		AudioServer.remove_bus_effect(0, 0)


func _on_main_menu_pressed() -> void:
	AudioManager.play_sfx(AudioManager.SoundEffects.MENU_BUTTON)
	Engine.time_scale = 1
	get_tree().change_scene_to_file("res://scenes/menu.tscn")
