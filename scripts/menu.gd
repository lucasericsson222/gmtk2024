extends Control


func _ready() -> void:
	if not GlobalVars.main_menu_music_playing:
		AudioManager.play_song(AudioManager.Songs.MENU)
	GlobalVars.main_menu_music_playing = true


func _on_play_pressed() -> void:
	AudioManager.play_sfx(AudioManager.SoundEffects.MENU_BUTTON)
	GlobalVars.main_menu_music_playing = false
	get_tree().change_scene_to_file("res://scenes/world.tscn")


func _on_options_pressed() -> void:
	AudioManager.play_sfx(AudioManager.SoundEffects.MENU_BUTTON)
	get_tree().change_scene_to_file("res://scenes/options_menu.tscn")


func _on_credits_pressed() -> void:
	AudioManager.play_sfx(AudioManager.SoundEffects.MENU_BUTTON)
	get_tree().change_scene_to_file("res://scenes/credits_menu.tscn")
