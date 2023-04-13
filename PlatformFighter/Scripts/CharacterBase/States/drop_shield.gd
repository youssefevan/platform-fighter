extends BaseState

var frame = 0

func enter():
	.enter()
	frame = 0

func physics_process(delta):
	frame += 1
	
	if char_base.shield_break == true:
		print(frame, "/", char_base.shield_break_frames)
		if frame == char_base.shield_break_frames:
			return char_base.idle
	else:
		if frame == char_base.drop_shield_frames:
			return char_base.idle
	
	if char_base.got_hit == true:
		return char_base.hitstun
	
	if char_base.respawning == true:
		return char_base.respawn

func exit():
	.exit()
	char_base.shield_break = false
	print(char_base.shield_break)
