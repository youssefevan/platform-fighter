extends Node2D

export var player_number: int
var abe = load("res://Scenes/Characters/Red.tscn").instance()
var george = load("res://Scenes/Characters/Timber.tscn").instance()

func _ready():
	if player_number == 1:
		if gm.p1_char == "abe":
			abe.port = 1
			add_child(abe)
		elif gm.p1_char == "george":
			george.port = 1
			add_child(george)
	elif player_number == 2:
		if gm.p2_char == "abe":
			abe.port = 2
			add_child(abe)
		elif gm.p2_char == "george":
			george.port = 2
			add_child(george)
