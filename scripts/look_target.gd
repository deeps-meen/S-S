extends Marker3D

#Mouse sensitivity
@export_range(-10,10,0.1) var acc:float = 1.0

#Refrence to player
@export_node_path("CharacterBody3D") var target:NodePath

#Camera adjustment
@export var view_offset:Vector3
@export var cam_offset:Vector3

#Point where camera will focus; calulated in process
var viewpoint:Vector3
var _target:CharacterBody3D#Nide refrence
var _cam:Camera3D#Camera refrence

var _rotX2D:Vector2#Mouse movement tracker

# Called when the node enters the scene tree for the first time.
func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	_target = get_node(target)
	_cam = get_viewport().get_camera_3d()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	var p_transform:Transform3D = _target.transform
	#Set this node at the player position
	position = lerp(position,_target.global_position,5.0*delta)
	
	
	#Roatate the node based on mouse movement
	var ry:Vector3 = _target.rotation
	#rotation.y= clamp(rotation.y,ry.y-1.22173,ry.y+1.22173)
	#rotation.x= clamp(rotation.x,-0.523599,0.523599)
	var rQuat:Quaternion = Basis.from_euler(basis.get_euler()+Vector3(_rotX2D.y*delta*acc,-_rotX2D.x*delta*acc,0)).get_rotation_quaternion()
	quaternion = quaternion.slerp(rQuat,acc*delta).normalized()
	
	#calculate the point to look at, front of player
	viewpoint = lerp(viewpoint,transform*view_offset,10*delta)
	_cam.look_at_from_position(lerp(_cam.position,p_transform*cam_offset,2.0*delta),viewpoint)
	transform=transform.orthonormalized()
	_rotX2D = Vector2.ZERO
	

func  _input(event):
	if event is InputEventMouseMotion:
		_rotX2D += event.relative


