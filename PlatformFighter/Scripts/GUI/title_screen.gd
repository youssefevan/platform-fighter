extends Node2D

#var hitstun_arc = preload("res://Scenes/Particles/HitstunArc.tscn")
#
#var particles = [
#	hitstun_arc
#]
#
#func ready():
#	for i in particles:
#		var particles_instance = Particles2D.new()
#		particles_instance.position = Vector2(-64, -64)
#		particles_instance.set_process_material(particles)
#		particles_instance.set_one_shot(true)
#		particles_instance.set_emitting(true)
#		self.add_child(particles_instance)

func _on_StartBtn_button_up():
	gm.in_char_select = true
	get_tree().change_scene("res://Scenes/GUI/CharSelectScreen.tscn")
