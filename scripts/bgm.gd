extends AudioStreamPlayer2D


func _process(delta):
	if (GameManager.bgm_muted):
		volume_db = -80
	else:
		volume_db = GameManager.bgm_vol
