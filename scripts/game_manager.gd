extends Node

var time_counter = 0

var bgm_vol: float = 1.0
var sfx_vol: float = 1.0
var bgm_muted: bool = false
var sfx_muted: bool = false
var is_started: bool = false
var is_paused: bool = false
var is_hard: bool = false
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
		

func _physics_process(delta):
	if (is_started):
		time_counter += delta

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
			get_tree().paused = true
		else:
			get_tree().paused = false
	option_ui.visible = !option_ui.visible

func get_formatted_time():
	var minutes = time_counter / 60.0
	var seconds = fmod(time_counter, 60.0)
	var millisec = fmod(time_counter * 1000, 1000) / 10
	return str(round(minutes)).pad_zeros(2) + ":" + str(round(seconds)).pad_zeros(2) + ":" + str(round(millisec)).pad_zeros(2)
