extends Label

func _physics_process(delta):
	text = str(gm.p1_percent) + "%"
