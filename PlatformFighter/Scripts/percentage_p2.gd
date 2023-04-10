extends Label


func _physics_process(delta):
	text = str(gm.p2_percent) + "%"
