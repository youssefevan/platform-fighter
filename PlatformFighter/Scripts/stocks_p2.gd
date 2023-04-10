extends Label

func _physics_process(delta):
	text = "x" + str(gm.p2_stocks)
