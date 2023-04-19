extends Node2D

func _ready():
	gm.p1_stocks = gm.starting_stock_count
	gm.p2_stocks = gm.starting_stock_count
	gm.in_char_select = true
	$Cursor.visible = false

func _unhandled_input(event):
	if event is InputEvent:
		if event.is_action_pressed("attack"):
			# if player 1 doesn't currently have an assigned device
			if gm.p1_device == null:
				# assign the device of the input event to player 1
				gm.p1_device = event.get_device()
				print("P1: Device ", event.get_device())
				#$Cursor.visible = true
			
			# if player 1 is assigned and player 2 isn't and the input event device wasn't player 1's device
			elif gm.p2_device == null and event.get_device() != gm.p1_device: 
				# assign the device of the input event to player 2
				gm.p2_device = event.get_device()
				print("P2: Device ", event.get_device())

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
