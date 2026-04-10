extends Control

@onready var MenuMusic = $"../music"
@onready var musicBox = $Music
@onready var SFXBox = $SFX

func _ready() -> void:
	if global.Music_Enabled:
		musicBox.button_pressed = true
		MenuMusic.playing = true
	else:
		musicBox.button_pressed = false
		MenuMusic.playing = false
	if global.SFX_Enabled:
		SFXBox.button_pressed = true
	else:
		SFXBox.button_pressed = false
	

func _on_music_toggled(toggled_on: bool) -> void:
	global.Music_Enabled = toggled_on
	MenuMusic.playing = toggled_on


func _on_sfx_toggled(toggled_on: bool) -> void:
	global.SFX_Enabled = toggled_on
