extends Particles2D

func _ready():
	emitting = true

func _physics_process(delta):
	if emitting == false:
		yield(get_tree().create_timer(lifetime), "timeout")
		call_deferred("free")
