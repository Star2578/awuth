extends Control

func _ready():
	$TextureRect/AnimationPlayer.play("bg")

func to_test_scene():
	get_tree().change_scene_to_file("res://levels/building_level.tscn")
	
func quit():
	get_tree().quit()

func on_bgm_finished():
	$AudioStreamPlayer2D.play()
