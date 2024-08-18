extends Control


func _ready() -> void:
	if AudioServer.is_bus_mute(0):
		$MarginContainer/VBoxContainer/Volume.value = -20
	else:
		$MarginContainer/VBoxContainer/Volume.value = AudioServer.get_bus_volume_db(0)


func _on_back_pressed() -> void:
	AudioManager.play_sfx(AudioManager.SoundEffects.MENU_BUTTON)
	get_tree().change_scene_to_file("res://scenes/menu.tscn")


func _on_volume_value_changed(value: float) -> void:
	if value == -20:
		AudioServer.set_bus_mute(0, true)
	else:
		AudioServer.set_bus_mute(0, false)
		AudioServer.set_bus_volume_db(0, value)


func _on_controls_pressed() -> void:
	AudioManager.play_sfx(AudioManager.SoundEffects.MENU_BUTTON)
	get_tree().change_scene_to_file("res://scenes/controls_menu.tscn")
