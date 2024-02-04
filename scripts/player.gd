extends CharacterBody3D

<<<<<<< HEAD
=======
class_name Game_Player
>>>>>>> d5c54e40f3f9dd15e497093e83fe3f0f797538b4

const SPEED = 5.0
const JUMP_VELOCITY = 4.5

<<<<<<< HEAD
# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

=======
signal attack_end

@onready var _anim = %AnimationTree

@export_range(0.1,1.0, 0.01) var recover_stamina_speed:float

@export_node_path("Marker3D") var view_point:NodePath

var _cam:Camera3D
var _view:Marker3D
var _follow_cam:bool = true
# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

func _ready():
	
	#set tween timer
	_anim.recovery_speed = recover_stamina_speed
	_cam = get_viewport().get_camera_3d()
	_view = get_node(view_point)
>>>>>>> d5c54e40f3f9dd15e497093e83fe3f0f797538b4

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y -= gravity * delta

<<<<<<< HEAD
	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY
=======
>>>>>>> d5c54e40f3f9dd15e497093e83fe3f0f797538b4

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
<<<<<<< HEAD
	var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)

	move_and_slide()
=======
	var direction = (get_quaternion() * _anim.get_root_motion_rotation())
	velocity = direction* _anim.get_root_motion_rotation()*(_anim.get_root_motion_position()/delta)
	if direction != Quaternion.IDENTITY:
		transform.basis =Basis(direction).orthonormalized()

	#Look in camera direction
	var vp:= Quaternion.from_euler(_view.global_transform.basis.get_rotation_quaternion().get_euler()*Vector3.UP)#Quat that contain y rotation only
	set_quaternion(vp.slerp(quaternion,delta).normalized())
	move_and_slide()
	
func _process(delta):
	if Input.is_action_pressed("move_forward"):
		if Input.is_action_pressed("sprint"):
			_anim.anim = _anim.codes.RUN
			_anim.sprint = -1#--sprint
		else:
			_anim.anim = _anim.codes.WALK
	elif  Input.is_action_pressed("jump"):
		_anim.anim = _anim.codes.JUMP
	elif  Input.is_action_pressed("move_back"):
		_anim.anim = _anim.codes.BACK
	elif Input.is_action_pressed("emote"):
		_anim.anim = _anim.codes.EMOTE
	elif Input.is_action_pressed("E"):
		if Combat.locktarget():
			_anim.anim = _anim.codes.STEALTH
			var newAtt:= ATTACK.new(ATTACK.new(self))
			connect("attack_end",Callable(newAtt,"finish"))
			Combat.launch_attack(newAtt)
	else:
		_anim.anim = _anim.codes.IDLE

#func _unhandled_input(event):
	#if (event is InputEvent) and (event.is_action("emote")) and event.is_action_pressed("emote"):

#For attacks that requires player to be at certain location (from oher players) for animation to work.
#Possibly called from animation.
func snap_to_target()->void:
	disableCollision()
	var tPlayer:CharacterBody3D = Combat.get_target()
	transform.origin = tPlayer.position
	transform.basis = tPlayer.transform.basis
	#transform.basis

func attak_finished()->void:
	emit_signal("attack_end")
	Combat.unlocktarget()
	disableCollision(false)

func  disableCollision(flag:bool=true)->void:
	$CollisionShape3D.disabled = flag
>>>>>>> d5c54e40f3f9dd15e497093e83fe3f0f797538b4
