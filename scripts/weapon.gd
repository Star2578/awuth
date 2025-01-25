extends RigidBody2D

var torque_strength: float = 1000.0  # Torque for spinning the weapon
var max_angular_speed: float = 10.0  # Limit for angular velocity
var damping: float = 0.9  # General damping for angular velocity
var dash_force:float = 1.25
#var torque_direction = 1 # rotation pivot (1 or -1)

var can_dash:bool = true

var init_pos

var rotation1
var rotation2
var last_touch_point: Node2D

var prev_mouse_pos

func _ready():
	init_pos = position
	rotation1 = $Area2D/Rotation1
	rotation2 = $Area2D/Rotation2
	last_touch_point = rotation1
	prev_mouse_pos = get_global_mouse_position()

func _process(delta):
	# For debugging
	#print(last_touch_point.name)
	var mouse_pos = get_global_mouse_position()
	var to_mouse = mouse_pos - last_touch_point.global_position
	
	#reset position
	if (Input.is_key_pressed(KEY_R)):
		position = init_pos
	
	#dash
	if (Input.is_key_pressed(KEY_SHIFT) && can_dash):
		apply_impulse(to_mouse.normalized() * 1000)
		can_dash = false
	
	# trigger once when LMB pressed down
	#if (Input.is_action_just_pressed("ui_select")):
		#change_torque_direction(mouse_pos)
	
	var angle_to_mouse = to_mouse.angle()
	var angle_diff = wrapf(angle_to_mouse - rotation, -PI, PI)
	var torque = angle_diff * torque_strength
	apply_torque_impulse(torque)

	prev_mouse_pos = mouse_pos
	
	if abs(angular_velocity) > max_angular_speed:
		angular_velocity = sign(angular_velocity) * max_angular_speed
	
func _integrate_forces(state: PhysicsDirectBodyState2D):
	angular_velocity *= damping

func reset_dash():
	can_dash = true;

func _on_touch_ground(body):
	reset_dash()
