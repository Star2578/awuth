extends Control

func to_test_scene():
	get_tree().change_scene_to_file("res://levels/building_level.tscn")
	
func quit():
	get_tree().quit()
