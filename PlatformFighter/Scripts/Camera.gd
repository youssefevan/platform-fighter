extends Camera2D

var h_setting := 1 # 0 zoom_out; 1 nuetral; 2 zoom in
var v_setting := 1 # 0 zoom_out; 1 nuetral

func _ready():
	h_setting = 1
	v_setting = 1

func _physics_process(delta):
	if gm.char_dist_x >= 150:
		h_setting = 0
	elif gm.char_dist_x <= 50:
		h_setting = 2
	else:
		h_setting = 1
	
	if gm.player1 != null || gm.player2 != null:
		if gm.player1.global_position.y < 50 || gm.player2.global_position.y < 50 || gm.player1.global_position.y > 200 || gm.player2.global_position.y > 200:
			v_setting = 0
		else:
			v_setting = 1
	
	adjust_zoom(delta)

func adjust_zoom(delta):
	if v_setting == 0:
		zoom.x = lerp(zoom.x, 1.2, 12 * delta)
		zoom.y = lerp(zoom.y, 1.2, 12 * delta)
	else:
		if h_setting == 0:
			zoom.x = lerp(zoom.x, 1.2, 12 * delta)
			zoom.y = lerp(zoom.y, 1.2, 12 * delta)
		elif h_setting == 1:
			zoom.x = lerp(zoom.x, 1, 12 * delta)
			zoom.y = lerp(zoom.y, 1, 12 * delta)
		elif h_setting == 2:
			zoom.x = lerp(zoom.x, .8, 12 * delta)
			zoom.y = lerp(zoom.y, .8, 12 * delta)
