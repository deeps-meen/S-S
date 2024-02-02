extends SpringArm3D


@onready var cam = $Camera3D

var sensitivity = 0.18
var cam_cap = true
var max_pitch_angle = 65.0  # Adjust this value for desired maximum pitch
var min_pitch_angle = -75.0


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
		if cam_cap:
			var rotation_change = Vector3(
				-event.relative.y * sensitivity,
				-event.relative.x * sensitivity,
				0
			)

			# Apply rotation changes
			var current_rotation = get_rotation_degrees()
			current_rotation.x = clamp(current_rotation.x + rotation_change.x, min_pitch_angle, max_pitch_angle)
			current_rotation.y += rotation_change.y

			# Apply the new rotation
			set_rotation_degrees(current_rotation)
