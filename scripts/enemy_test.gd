extends CharacterBody3D


const SPEED = 3.0
const JUMP_VELOCITY = 4.5

@onready var nav_agent = $NavigationAgent3D

@export var player : Node

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")
var is_chasing = false
var is_fighting = false


func _physics_process(delta):
	# Not Moving
	velocity = Vector3.ZERO

	
	# Add the gravity.
	if not is_on_floor():
		velocity.y -= gravity * delta
	if is_chasing:
		var target = player.global_transform.origin
		target.y = global_transform.origin.y
		look_at(target, Vector3.UP)
		nav_agent.set_target_position(player.global_transform.origin)
		var next_nav_point = nav_agent.get_next_path_position()
		velocity = (next_nav_point - global_transform.origin).normalized() * SPEED
		
	if is_fighting:
		var target = player.global_transform.origin
		target.y = global_transform.origin.y
		look_at(target, Vector3.UP)

	move_and_slide()


func _on_detect_zone_body_entered(body):
	if body == player:
		#player = body
		is_chasing = true
		print("Hey")
		pass
	pass # Replace with function body.


func _on_detect_zone_body_exited(body):
	if body == player:
		is_chasing = false
		print("Well damn")
	pass # Replace with function body.


func _on_fight_zone_body_entered(body):
	if body == player:
		velocity = Vector3.ZERO
		is_chasing = false
		is_fighting = true
		pass
	pass # Replace with function body.


func _on_fight_zone_body_exited(body):
	if body == player:
		is_chasing = true
		is_fighting = false
	pass # Replace with function body.
