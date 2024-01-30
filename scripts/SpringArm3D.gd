extends SpringArm3D


@onready var cam = $Camera3D

var sensitivity = 0.001
var cam_cap = true
var max_pitch_angle = 85.0  # Adjust this value for desired maximum pitch
var min_pitch_angle = -85.0


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
		
	#Shoulder swap for Camera
	if Input.is_action_just_pressed("cam_swap"):
		if cam.h_offset == 0.5:
			cam.h_offset = -0.1
		else:
			cam.h_offset = 0.5

func _input(event):
	if event is InputEventMouseMotion:
		if cam_cap == true:
			var pitch_change = -event.relative.y * sensitivity
			var new_pitch = clamp(rotation.x + pitch_change, min_pitch_angle, max_pitch_angle)
			rotation.x = new_pitch
			
			rotate(Vector3.UP, -event.relative.x * sensitivity)
			rotate_object_local(Vector3.RIGHT, -event.relative.y * sensitivity)
		pass
