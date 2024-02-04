extends Node

#Autolooad for handeling combats

var _current_target:Node3D

var _lock_target

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func launch_attack(attack_data:ATTACK)->void:
	#Simply play defend animation for now
	attack_data.defender = _lock_target
	if _lock_target is Npc_Player:
		_lock_target.set_animation(Anim_Tree.codes.STEALTHDEFEND)

func set_target(target_node)->void:
	if !_lock_target:
		_current_target = target_node

func get_target()->Node3D:
	return _lock_target

func locktarget()->bool:
	if (_current_target) and (not _lock_target):
		_lock_target = _current_target
		return true
	return false

func unlocktarget()->void:
	_lock_target = null
