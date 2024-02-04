extends AnimationTree

class_name Anim_Tree

const SPRINT_TIME = 100
enum codes {IDLE,WALK,RUN,JUMP,BACK,EMOTE,STEALTH,STEALTHDEFEND};
enum walk {CAT,INJURED,PHONE}

var recovery_speed:float = 0.1

#Number of seconds player being in idle mode; resets on any new input; use to toggle idle animation
var _idle_time:int = 0
var _past_frame_anim_code:codes = codes.IDLE
var _idle_anim:int = 0
var _walk_mode:walk = walk.CAT
var _emote_toggle:bool

var sprint:int = SPRINT_TIME :
	set(value):
		sprint  = min(sprint+value,SPRINT_TIME) if (value>0) else  max(sprint+value,0)
			#print(value)

var anim:int =0:
	set(value):
		anim = value
		set_animation(value)

# Called when the node enters the scene tree for the first time.
func _ready():
	active = true
	#tween to recover sprint
	var tw:= create_tween().set_loops()
	tw.tween_callback(func ():sprint = 1).set_delay(recovery_speed)
	tw.play()
	
func set_animation(anim_code:int)->void:
	
	if anim_code == _past_frame_anim_code:
		if anim_code == codes.IDLE: 
			_idle_time +=1
			if _idle_time*0.016 > 20:
				_idle_anim = randi_range(1,2)
				_idle_time = 0
				set_deferred("_idle_anim",0)
		else:
			_idle_time = 0
		return
	set_deferred("_past_frame_anim_code", anim_code)

	match  anim_code:
		codes.IDLE:
			if (_past_frame_anim_code == codes.WALK) and (_walk_mode == walk.CAT):
				set("parameters/Transition/transition_request","walk_stop")
				set("parameters/switch/transition_request","idle")
				set("parameters/walkstop/request",true)
			elif  (_past_frame_anim_code == codes.RUN):
				set("parameters/Transition/transition_request","run_stop")
				set("parameters/walkstop/request",true)
			elif _past_frame_anim_code == codes.EMOTE:
				pass
			else:
				set_deferred("parameters/switch/transition_request","idle")
		codes.WALK:
			set("parameters/emoteShot/request","abort")
			_walk_mode = walk.CAT
			set("parameters/switch/transition_request","walk")
		codes.RUN:
			set("parameters/switch/transition_request","run")
		codes.BACK:
			set("parameters/turnback/request",true)
		codes.JUMP:
			set("parameters/walk/conditions/jump",true)
		codes.EMOTE:
			set("parameters/switch/transition_request","emote")
		codes.STEALTH:
			set("parameters/attack_mode/attacks/transition_request","stealth")
			set("parameters/attack/request",true)
		codes.STEALTHDEFEND:
			set("parameters/attack_mode/attacks/transition_request","defend")
			set("parameters/attack/request",true)
			
		_:
			pass
