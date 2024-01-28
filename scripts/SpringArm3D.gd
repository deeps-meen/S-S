extends SpringArm3D


@onready var cam = $Camera3D

var sensitivity = 0.001
var cam_cap = true


func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	cam.h_offset = .5

func _process(_delta):
	# Toggle camera mode on a key press
	if Input.is_action_just_pressed("capture_cam"):
		if Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
			cam_cap = false
		elif Input.get_mouse_mode() == Input.MOUSE_MODE_VISIBLE:
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
			cam_cap = true
			
	if Input.is_action_just_pressed("cam_in") and spring_length > 1.5:
		spring_length -= 0.5
		pass
	if Input.is_action_just_pressed("cam_out") and spring_length < 4:
		spring_length += 0.5
		pass

func _input(event):
	if event is InputEventMouseMotion:
		if cam_cap == true:
			rotate(Vector3.UP, -event.relative.x * sensitivity)
			rotate_object_local(Vector3.RIGHT, -event.relative.y * sensitivity)
		pass
