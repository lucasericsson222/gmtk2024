extends Node2D

var paused = false
@onready var pause_menu: Control = $Camera/PauseMenu


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _input(event: InputEvent) -> void:
	if event.is_action_pressed("pause"):
		pauseMenu()

func pauseMenu():
	paused = !paused
	AudioManager.play_sfx(AudioManager.SoundEffects.MENU_BUTTON)
	
	if paused:
		pause_menu.show()
		Engine.time_scale = 0
	else:
		pause_menu.hide()
		Engine.time_scale = 1
