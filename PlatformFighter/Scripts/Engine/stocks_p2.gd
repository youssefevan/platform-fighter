extends Label

func _physics_process(delta):
	if gm.p2_stocks == 3:
		text = "xxx"
	elif gm.p2_stocks == 2:
		text = "xx"
	elif gm.p2_stocks == 1:
		text = "x"
