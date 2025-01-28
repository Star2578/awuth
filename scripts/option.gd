extends Control

var bgm_slider: HSlider
var sfx_slider: HSlider
var bgm_mute_checkbox: CheckBox
var sfx_mute_checkbox: CheckBox

func _ready():
	bgm_slider = $TextureRect/BGM/BGM_Slider
	sfx_slider = $TextureRect/SFX/SFX_Slider
	bgm_mute_checkbox = $TextureRect/BGM/CheckBox
	sfx_mute_checkbox = $TextureRect/SFX/CheckBox
	
	bgm_slider.value = GameManager.bgm_vol
	sfx_slider.value = GameManager.sfx_vol
	bgm_mute_checkbox.button_pressed = GameManager.bgm_muted
	sfx_mute_checkbox.button_pressed = GameManager.sfx_muted

func _on_bgm_slider_value_changed(value):
	GameManager.bgm_vol = value
	if (!GameManager.bgm_muted):
		GameManager.audio_player.volume_db = value

func _on_sfx_slider_value_changed(value):
	GameManager.sfx_vol = value

func _on_mute_bgm_check(checked):
	GameManager.bgm_muted = checked
	if (checked):
		GameManager.audio_player.volume_db = -80
	else:
		GameManager.audio_player.volume_db = GameManager.bgm_vol

func _on_mute_sfx_check(checked):
	GameManager.sfx_muted = checked

func close():
	GameManager.toggle_option()
