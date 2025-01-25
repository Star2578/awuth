extends RigidBody2D

var time = 1
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	set_process(false)
	freeze = true
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	time += 1
	$ColorRect.position += Vector2(0,sin(time)*5)

func _on_area_2d_body_entered(body: Node2D) -> void:
	# start falling animation then fall over time
	if body.name == "Weapon":
		set_process(true)
		$Area2D.queue_free()
		$Timer.start(3)
		
func _on_timer_timeout() -> void:
	freeze = false
	set_process(false)

	
