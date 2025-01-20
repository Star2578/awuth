extends RigidBody2D

var torque_strength: float = 1000.0  # Torque for spinning the weapon
var max_angular_speed: float = 10.0  # Limit for angular velocity
var damping: float = 0.95  # General damping for angular velocity

var init_pos

var rotation1
var rotation2
var last_touch_point: Node2D

func _ready():
	init_pos = position
	rotation1 = $Area2D/Rotation1
	rotation2 = $Area2D/Rotation2
	last_touch_point = rotation1

func _process(delta):
	# For debugging
	if (Input.is_key_pressed(KEY_R)):
		position = init_pos
	
	var mouse_pos = get_global_mouse_position()
	
	var to_mouse = mouse_pos - last_touch_point.global_position
	var angle_to_mouse = to_mouse.angle()

	var angle_diff = wrapf(angle_to_mouse - rotation, -PI, PI)

	var torque = angle_diff * torque_strength
	apply_torque_impulse(torque)

	if abs(angular_velocity) > max_angular_speed:
		angular_velocity = sign(angular_velocity) * max_angular_speed

func _integrate_forces(state: PhysicsDirectBodyState2D):
	angular_velocity *= damping

func _on_collision_with_ground(body):
	var collision_point = body.global_position
	if rotation1.global_position.distance_to(collision_point) < rotation2.global_position.distance_to(collision_point):
		last_touch_point = rotation1
	else:
		last_touch_point = rotation2
	#print("Last touched: ", last_touch_point)
