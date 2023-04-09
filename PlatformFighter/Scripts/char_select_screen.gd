extends Node2D

func _ready():
	gm.in_char_select = true

func _on_FightBtn_button_up():
	if $SpriteP1.frame == 0:
		gm.p1_char = "abe"
	elif $SpriteP1.frame == 1:
		gm.p1_char = "george"
	
	if $SpriteP2.frame == 0:
		gm.p2_char = "abe"
	elif $SpriteP2.frame == 1:
		gm.p2_char = "george"
	
	gm.in_char_select = false
	get_tree().change_scene("res://World.tscn")

func _on_ChangeP1_button_up():
	if $SpriteP1.frame == 0:
		$SpriteP1.frame = 1
	elif $SpriteP1.frame == 1:
		$SpriteP1.frame = 0

func _on_ChangeP2_button_up():
	if $SpriteP2.frame == 0:
		$SpriteP2.frame = 1
	elif $SpriteP2.frame == 1:
		$SpriteP2.frame = 0
