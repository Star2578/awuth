extends Control

func _ready():
	$TextureRect/AnimationPlayer.play("bg")

func to_test_scene():
	GameManager.is_started = true
	get_tree().change_scene_to_file("res://levels/building_level.tscn")

func option():
	#GameManager.option_ui.reparent(get_tree().current_scene)
	GameManager.toggle_option()

func quit():
	get_tree().quit()
