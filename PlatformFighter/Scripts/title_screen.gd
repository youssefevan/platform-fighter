extends Node2D

func _on_StartBtn_button_up():
	gm.in_char_select = true
	get_tree().change_scene("res://Scenes/CharSelectScreen.tscn")
