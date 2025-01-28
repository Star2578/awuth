extends RigidBody2D

var torque_strength: float = 1000.0  # Torque for spinning the weapon
var max_angular_speed: float = 10.0  # Limit for angular velocity
var damping: float = 0.9  # General damping for angular velocity
var dash_force: float = 1000

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

func _process(delta):
	if (GameManager.is_paused):
		return
	
	var mouse_pos = get_global_mouse_position()
	var to_mouse = mouse_pos - last_touch_point.global_position
	
	
	# Reset position
	if (Input.is_key_pressed(KEY_R)):
		position = init_pos
	
	# Dash
	if Input.is_action_just_pressed("dash") and can_dash:
		print("prepare-dash")
		sprite.modulate = "#ffffff"
		smooth_timescale(0.05, 0.1)
		
	if Input.is_action_just_released("dash") and can_dash:
		print("activate-dash")
		sprite.modulate = cannot_dash
		Engine.time_scale = 1.0
		get_viewport().get_camera_2d().zoom = Vector2(0.45, 0.45)
		apply_impulse(to_mouse.normalized() * dash_force)
		can_dash = false
		
	if (can_dash == false && Engine.time_scale != 1.0):
		Engine.time_scale = 1.0
	
	var angle_to_mouse = to_mouse.angle()
	var angle_diff = wrapf(angle_to_mouse - rotation, -PI, PI)
	var torque = angle_diff * torque_strength
	apply_torque_impulse(torque)
	
	if abs(angular_velocity) > max_angular_speed:
		angular_velocity = sign(angular_velocity) * max_angular_speed
	
func _integrate_forces(state: PhysicsDirectBodyState2D):
	angular_velocity *= damping

func reset_dash():
	sprite.modulate = "#ffffff"
	can_dash = true;

func _on_touch_ground(body):
	reset_dash()
	
func smooth_timescale(target_time_scale: float, in_time: float):
	var camera = get_viewport().get_camera_2d()
	var tween_t = create_tween()
	var tween_c = create_tween()
	tween_t.tween_property(Engine, "time_scale", target_time_scale, in_time)
	tween_c.tween_property(camera, "zoom", Vector2(0.5, 0.5), in_time)
