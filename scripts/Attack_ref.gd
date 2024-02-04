extends RefCounted

class_name ATTACK
#Class for handlind attac data

var TimeOfStart:int
var offencer
var defender
var attackType
var damage

func  _init(attackingPlayer=null,defendingPlayer=null):
	TimeOfStart = Time.get_ticks_msec()

func finish()->void:
	if defender is Npc_Player:
		defender.set_animation(Anim_Tree.codes.IDLE)
