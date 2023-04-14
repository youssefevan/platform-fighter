extends CanvasLayer

var hitstun_arc = preload("res://Scenes/Particles/HitstunArc.tscn")

var particles = [
	hitstun_arc
]

func ready():
	for i in particles:
		var particles_instance = Particles2D.new()
		particles_instance.position = Vector2(-64, -64)
		particles_instance.set_process_material(particles)
		particles_instance.set_one_shot(true)
		particles_instance.set_emitting(true)
		self.add_child(particles_instance)
