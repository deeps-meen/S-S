extends ParallaxBackground

@onready var clouds = $clouds
@onready var clouds_2 = $clouds2

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	clouds.motion_offset+= Vector2(20.0,0)*delta
	clouds_2.motion_offset-= Vector2(5.0,0)*delta

func _unhandled_key_input(event):
	if event.is_action("ui_cancel"):
		get_tree().quit()


func _on_start_button_up():
	get_tree().change_scene_to_file("res://scenes/world.tscn")


func _on_exit_button_down():
	get_tree().quit()
