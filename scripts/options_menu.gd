extends Control


func _ready() -> void:
	$MarginContainer/VBoxContainer/Volume.value = AudioServer.get_bus_volume_db(0)


func _on_back_pressed() -> void:
	AudioManager.play_sfx(AudioManager.SoundEffects.MENU_BUTTON)
	get_tree().change_scene_to_file("res://scenes/menu.tscn")


func _on_volume_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"), value)
	AudioManager.play_sfx(AudioManager.SoundEffects.MENU_BUTTON)


func _on_controls_pressed() -> void:
	AudioManager.play_sfx(AudioManager.SoundEffects.MENU_BUTTON)
	get_tree().change_scene_to_file("res://scenes/controls_menu.tscn")
