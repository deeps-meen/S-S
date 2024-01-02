extends CharacterBody3D

enum PlayerState {
	IDLE,
	WALK,
	RUN,
	LIGHT_ATTACK_1,
	LIGHT_ATTACK_2
}

const SPEED = 2.0
const JUMP_VELOCITY = 4.5
const LERP_VAL = .15

@onready var spring = $SpringArm3D
@onready var rig = $rig
@onready var anim_tree = $AnimationTree
@onready var current_state : PlayerState = PlayerState.IDLE

var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")
var cam_facing = Vector3.ZERO
var is_sprinting = false
var move_speed = 0.0
var sprint_speed = 4.0


func _ready():
	move_speed = SPEED
	pass

func _input(event):
	if event.is_action_pressed("light_attack"):
		print("tacos")
		pass
	pass

func _physics_process(delta):
	cam_facing = spring.rotation.y
	# Add the gravity.
	if not is_on_floor():
		velocity.y -= gravity * delta

	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	var input_dir = Input.get_vector("move_left", "move_right", "move_forward", "move_back")
	var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	direction = direction.rotated(Vector3.UP, cam_facing)
	if direction:
		current_state = PlayerState.WALK
		velocity.x = lerp(velocity.x, direction.x * move_speed, LERP_VAL)
		velocity.z = lerp(velocity.z, direction.z * move_speed, LERP_VAL)
		rig.rotation.y = lerp_angle(rig.rotation.y, atan2(-velocity.x, -velocity.z), LERP_VAL)
	else:
		velocity.x = lerp(velocity.x, 0.0, LERP_VAL)
		velocity.z = lerp(velocity.z, 0.0, LERP_VAL)
	
	if Input.is_action_just_pressed("sprint"):
		if not is_sprinting:
			move_speed += sprint_speed
			is_sprinting = true
		elif is_sprinting:
			move_speed = SPEED
			is_sprinting = false
			pass
		pass
	
	# Animation Tree (In Progress)
	#anim_tree.set("parameters/BlendSpace1D/blend_position", velocity.length() / move_speed)

	move_and_slide()
	
	#Exit Game
	if Input.is_action_just_pressed("exit"):
		get_tree().quit()
