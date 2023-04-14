extends Node2D

func _on_ContBtn_button_up():
	gm.player1 = null
	gm.player2 = null
	gm.game_set = false
	get_tree().change_scene("res://Scenes/GUI/TitleScreen.tscn")
