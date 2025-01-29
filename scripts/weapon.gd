extends RigidBody2D

var torque_strength: float = 1600.0  # Torque for spinning the weapon
var max_angular_speed: float = 20.0  # Limit for angular velocity
var damping: float = 0.9  # General damping for angular velocity
var dash_force: float = 1500

var max_velocity_y = 1000

var on_floor: bool = false
var can_dash: bool = true
var dash_preparing: bool = false
var cannot_dash = "#00fff3" # Sprite modulate color while cannot dash

var init_pos: Vector2

var sprite: Sprite2D
var rotation1: CollisionShape2D
var rotation2: CollisionShape2D
var last_touch_point: Node2D

func _ready():
	init_pos = position
	sprite = $Sprite
	rotation1 = $Area2D/Rotation1
	rotation2 = $Area2D/Rotation2
	last_touch_point = rotation1
	
func _physics_process(delta):
	if (GameManager.is_paused):
		return
	
	var mouse_pos = get_global_mouse_position()
	var to_mouse = mouse_pos - last_touch_point.global_position

	# Reset position
	if (Input.is_key_pressed(KEY_R)):
		GameManager.time_counter = 0.0
		position = init_pos

		
	# Dash
	if Input.is_action_just_pressed("dash") and can_dash:
		print("prepare-dash")
		start_dash_transition()
	if Input.is_action_just_released("dash") and can_dash:
		print("activate-dash")
		can_dash = false
		sprite.modulate = cannot_dash
		await get_tree().create_timer(Engine.time_scale*0.1).timeout
		#reset transition to normal
		reset_dash_transition()
		
		if (!GameManager.is_hard):
			linear_velocity = Vector2(0,0)
			angular_velocity = 0
		var point_at = rotation1.global_rotation
		apply_impulse(to_mouse.normalized() * dash_force)
	
	# terminal velocity
	if (linear_velocity.y > max_velocity_y):
		linear_velocity.y = max_velocity_y
	
	
	# rotate character with mouse
	var angle_to_mouse = to_mouse.angle()
	var angle_diff = wrapf(angle_to_mouse - rotation, -PI, PI)
	var torque = angle_diff * torque_strength
	apply_torque_impulse(torque)
	
	if abs(angular_velocity) > max_angular_speed:
		angular_velocity = sign(angular_velocity) * max_angular_speed
	
func _integrate_forces(state: PhysicsDirectBodyState2D):
	angular_velocity *= damping
	#var i := 0
	#while i < state.get_contact_count():
	##check direction of contact vector
		#var normal := state.get_contact_local_normal(i)
		#on_floor = normal.dot(Vector2.UP) > 0.95 # false if pass threshold
		##  1.0 floor , 0.0 wall , -1.0 ceiling
		#i += 1

func try_reset_dash():
	#if (on_floor):
	sprite.modulate = "#ffffff"
	can_dash = true;

func start_dash_transition():
	var camera = get_viewport().get_camera_2d()
	var tween_t = create_tween()
	var tween_c = create_tween()
	tween_t.tween_property(Engine, "time_scale", 0.05, 0.1)
	tween_c.tween_property(camera, "zoom", Vector2(0.5, 0.5), 0.1)

func reset_dash_transition():
	Engine.time_scale = 1.0
	var camera = get_viewport().get_camera_2d()
	camera.zoom = Vector2(0.45, 0.45)


func _on_body_entered(body: Node) -> void:
	try_reset_dash()
