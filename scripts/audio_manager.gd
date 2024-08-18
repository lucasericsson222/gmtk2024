extends Node2D

enum SoundEffects {
	MENU_BUTTON
}

enum Songs {
	
}

const SFX_RESOURCES := {
	SoundEffects.MENU_BUTTON: preload("res://audio/menuSelect.wav")
}

const SONG_RESOURCES := {
	
}

func play_sfx(sfx: SoundEffects):
	$SFX.stream = SFX_RESOURCES[sfx]
	$SFX.play()

func play_song(song: Songs):
	$Music.stop()
	$Music.stream = SONG_RESOURCES[song]
	$Music.play()
