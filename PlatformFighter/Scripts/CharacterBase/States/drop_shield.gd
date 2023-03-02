extends BaseState

var frame = 0

func enter():
	.enter()
	frame = 0

func physics_process(delta):
	frame += 1
	if frame == char_base.drop_shield_frames:
		return char_base.idle
	
	if char_base.got_hit == true:
		return char_base.hitstun
