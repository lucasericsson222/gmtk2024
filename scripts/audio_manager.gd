extends Node2D

enum SoundEffects {
	MENU_BUTTON,
	ZOMBIE_GROAN_1,
	ZOMBIE_GROAN_2
}

enum Songs {
	MENU,
	MAIN,
	GAME_OVER,
	WIN
}

const SFX_RESOURCES := {
	SoundEffects.MENU_BUTTON: preload("res://audio/menu_select.wav"),
	SoundEffects.ZOMBIE_GROAN_1: preload("res://audio/zombie_1.wav"),
	SoundEffects.ZOMBIE_GROAN_2: preload("res://audio/zombie_2.wav")
}

const SONG_RESOURCES := {
	Songs.MENU: preload("res://audio/menu.mp3"),
	Songs.MAIN: preload("res://audio/main.mp3"),
	Songs.GAME_OVER: preload("res://audio/game_over.mp3"),
	Songs.WIN: preload("res://audio/win.mp3")
}

func play_sfx(sfx: SoundEffects):
	$SFX.stream = SFX_RESOURCES[sfx]
	$SFX.play()

func play_song(song: Songs):
	$Music.stop()
	$Music.stream = SONG_RESOURCES[song]
	$Music.play()
