extends Area2D


func _on_Blastzone_body_entered(body):
	if body.get_collision_layer() == 2:
		if body == gm.player1 or body == gm.player2:
			body.die()
