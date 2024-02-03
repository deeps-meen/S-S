extends Camera3D

@export_node_path("CharacterBody3D")  var player

@export var offset:Vector3
@onready var viewpoint = $"%viewpoint"

var _player:CharacterBody3D
# Called when the node enters the scene tree for the first time.
func _ready():
	_player = get_node(player)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	look_at_from_position(_player.global_transform*offset,viewpoint.global_position)
