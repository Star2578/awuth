extends Control

func _ready():
	$TextureRect/AnimationPlayer.play("bg")

func press_start():
	$Start.visible = false
	$Easy.visible = true
	$Hard.visible = true
	
func normal_start():
	GameManager.is_started = true
	GameManager.is_hard = false
	get_tree().change_scene_to_file("res://levels/building_level.tscn")

func speedrun_start():
	GameManager.is_started = true
	GameManager.is_hard = true
	get_tree().change_scene_to_file("res://levels/building_level.tscn")

func option():
	#GameManager.option_ui.reparent(get_tree().current_scene)
	GameManager.toggle_option()

func quit():
	get_tree().quit()
