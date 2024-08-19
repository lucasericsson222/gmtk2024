extends Node2D

enum SoundEffects {
	MENU_BUTTON
}

enum Songs {
	MENU,
	MAIN,
	GAME_OVER
}

const SFX_RESOURCES := {
	SoundEffects.MENU_BUTTON: preload("res://audio/menuSelect.wav")
}

const SONG_RESOURCES := {
	Songs.MENU: preload("res://audio/menu.mp3"),
	Songs.MAIN: preload("res://audio/main.mp3"),
	Songs.GAME_OVER: preload("res://audio/game_over.mp3")
}

func play_sfx(sfx: SoundEffects):
	$SFX.stream = SFX_RESOURCES[sfx]
	$SFX.play()

func play_song(song: Songs):
	$Music.stop()
	$Music.stream = SONG_RESOURCES[song]
	$Music.play()
