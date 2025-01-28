extends Node


var bgm_vol: float = 1.0
var sfx_vol: float = 1.0
var bgm_muted: bool = false
var sfx_muted: bool = false
var is_started: bool = false
var is_paused: bool = false
var audio_player: AudioStreamPlayer2D
var option_scn = preload("res://menus/option.tscn")
var option_ui: CanvasLayer

func _ready():
	print("GameManager Ready!")
	audio_player = Bgm
	audio_player.volume_db = bgm_vol
	option_ui = option_scn.instantiate()
	add_child(option_ui)
	option_ui.visible = false

func _process(delta):
	if (Input.is_action_just_pressed("option")):
		toggle_option()

func on_bgm_finished():
	audio_player.play()

func toggle_option():
	if (!option_ui):
		print("new option instance:", )
		option_ui = option_scn.instantiate()
		get_tree().current_scene.add_child(option_ui)
		option_ui.visible = true
	if (is_started):
		is_paused = !is_paused
		if (is_paused):
			Engine.time_scale = 0
		else:
			Engine.time_scale = 1
	option_ui.visible = !option_ui.visible
