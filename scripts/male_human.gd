extends CharacterBody3D


const SPEED = 2.0
const JUMP_VELOCITY = 4.5
const LERP_VAL = .15

@onready var spring = $SpringArm3D
@onready var rig = $rig
@onready var anim_tree = $AnimationTree

var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")
var cam_facing = Vector3.ZERO


func _ready():
	print(spring)
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
		velocity.x = lerp(velocity.x, direction.x * SPEED, LERP_VAL)
		velocity.z = lerp(velocity.z, direction.z * SPEED, LERP_VAL)
		rig.rotation.y = lerp_angle(rig.rotation.y, atan2(-velocity.x, -velocity.z), LERP_VAL)
	else:
		velocity.x = lerp(velocity.x, 0.0, LERP_VAL)
		velocity.z = lerp(velocity.z, 0.0, LERP_VAL)
		
	anim_tree.set("parameters/BlendSpace1D/blend_position", velocity.length() / SPEED)

	move_and_slide()
	
	if Input.is_action_just_pressed("exit"):
		get_tree().quit()
