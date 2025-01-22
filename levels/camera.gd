extends Camera2D

@export var target: Node2D
var boundX = 100.0
var boundY = 100.0
var smoothing_speed = 5.0

var desired_position: Vector2
var smoothed_position: Vector2

func _ready():
	offset.y = -200
	desired_position = global_position
	smoothed_position = global_position

func _process(delta):
	if not target:
		return

	var target_position = target.global_position + offset

	var delta_position = target_position - global_position
	if abs(delta_position.x) > boundX or abs(delta_position.y) > boundY:
		desired_position = target_position

	smoothed_position = smoothed_position.lerp(desired_position, smoothing_speed * delta)
	global_position = smoothed_position
