extends Label

func _physics_process(delta):
	if gm.p1_stocks == 3:
		text = "xxx"
	elif gm.p1_stocks == 2:
		text = "xx"
	elif gm.p1_stocks == 1:
		text = "x"
