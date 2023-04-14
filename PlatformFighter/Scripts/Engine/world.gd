extends Node2D

func _physics_process(delta):
	if gm.game_set == true:
		gm.player1 = null
		gm.player2 = null
		gm.game_set = false
		get_tree().change_scene("res://Scenes/GUI/GameSet.tscn")
