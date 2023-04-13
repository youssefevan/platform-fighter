extends BaseState

var frame = 0

func enter():
	.enter()
	frame = 0
	char_base.percentage = 0

func physics_process(delta):
	frame += 1
	if frame == 60:
		return char_base.idle

func exit():
	.exit()
	char_base.global_position = gm.angel_platform_position
	char_base.respawning = false
