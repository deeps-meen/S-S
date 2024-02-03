extends CharacterBody3D

class_name Npc_Player

const SPEED = 5.0
const JUMP_VELOCITY = 4.5

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")
@onready var _anim = $player/AnimationTree

func  _ready():
	_anim.anim = _anim.codes.IDLE

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y -= gravity * delta

	var direction = (get_quaternion() * _anim.get_root_motion_rotation())
	velocity = direction* _anim.get_root_motion_rotation()*(_anim.get_root_motion_position()/delta)
	if direction != Quaternion.IDENTITY:
		transform.basis =Basis(direction).orthonormalized()

	move_and_slide()

func set_animation(code:Anim_Tree.codes)->void:
	_anim.anim = code

func _process(delta):
	_anim.anim = 0
