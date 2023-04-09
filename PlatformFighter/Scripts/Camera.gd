extends Camera2D

func _physics_process(delta):
	if gm.char_dist_x >= 150:
		zoom.x = lerp(zoom.x, 1.2, 12 * delta)
		zoom.y = lerp(zoom.y, 1.2, 12 * delta)
	elif gm.char_dist_x >= 50:
		zoom.x = lerp(zoom.x, 1, 12 * delta)
		zoom.y = lerp(zoom.y, 1, 12 * delta)
	else:
		zoom.x = lerp(zoom.x, .8, 12 * delta)
		zoom.y = lerp(zoom.y, .8, 12 * delta)
