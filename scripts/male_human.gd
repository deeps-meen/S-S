extends CharacterBody3D

enum PlayerState {
	IDLE,
	WALK,
	RUN,
	LIGHT_ATTACK_1,
	LIGHT_ATTACK_2
}

const SPEED = 1.9
const JUMP_VELOCITY = 4.5
const LERP_VAL = .15

@onready var spring = $SpringArm3D
@onready var rig = $Node
@onready var anim_tree = $tree
@onready var current_state : PlayerState = PlayerState.IDLE
@onready var state_machine = anim_tree["parameters/playback"]
@onready var tree = get_tree()
@onready var parent = get_parent()

var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")
var cam_facing = Vector3.ZERO
var is_sprinting = false
var move_speed = 0.0
var sprint_speed = 6.0
var is_attacking = false
var is_dodging = false
var dodge_dir = Vector3.ZERO





func _ready():
	move_speed = SPEED
	pass

func _input(event):
	if event.is_action_pressed("light_attack") and not is_attacking:
		state_machine.stop()
		state_machine.travel("slash")
		is_attacking = true
		var _attacking = get_tree().create_timer(1.3).timeout.connect(func():
			is_attacking = false
		)
		
	else:
		pass

func _physics_process(delta):
	cam_facing = spring.rotation.y
	
	# Add the gravity.
	if not is_on_floor():
		velocity.y -= gravity * delta

	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		state_machine.stop()
		state_machine.travel("jump")
		velocity.y = JUMP_VELOCITY


	# Get the input direction and handle the movement/deceleration.
	var input_dir = Input.get_vector("move_left", "move_right", "move_forward", "move_back")
	var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	direction = -direction.rotated(Vector3.UP, cam_facing)
	if direction and not is_attacking and not is_dodging:
		if not is_sprinting:
			state_machine.travel("walk")
			current_state = PlayerState.WALK
		else:
			current_state = PlayerState.RUN
		velocity.x = lerp(velocity.x, -direction.x * move_speed, LERP_VAL)
		velocity.z = lerp(velocity.z, -direction.z * move_speed, LERP_VAL)
		dodge_dir = velocity
		rig.rotation.y = lerp_angle(rig.rotation.y, atan2(-velocity.x, -velocity.z), LERP_VAL)
	else:
		state_machine.travel("idle")
		velocity.x = lerp(velocity.x, 0.0, LERP_VAL)
		velocity.z = lerp(velocity.z, 0.0, LERP_VAL)
	
		
	if is_sprinting and direction and not is_attacking:
		state_machine.travel("sprint")
	
	if Input.is_action_just_pressed("sprint") and not is_dodging:
		if not is_sprinting:
			move_speed += sprint_speed
			is_sprinting = true
		elif is_sprinting:
			move_speed = SPEED
			is_sprinting = false
		else:
			pass
	
	if Input.is_action_pressed("dodge") and not is_dodging:
		is_dodging = true
		state_machine.travel("dodge")
		if not is_sprinting:
			move_speed += 2
		move_speed += .5
		var _dodging = get_tree().create_timer(0.9).timeout.connect(func():
			is_dodging = false
			move_speed = SPEED
			if is_sprinting:
				move_speed = 1
				var _recover = get_tree().create_timer(.5).timeout.connect(func():
					move_speed = SPEED + sprint_speed
				)
		)

	if is_dodging:
		velocity = dodge_dir * move_speed
		if is_sprinting:
			velocity = dodge_dir * (move_speed / 7)
	

	move_and_slide()
	
	#Exit Game
	if Input.is_action_just_pressed("exit"):
		get_tree().quit()
