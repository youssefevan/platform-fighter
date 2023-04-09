extends Node

var player1 : CharacterBase
var player2 : CharacterBase

var p1_stocks : int
var p2_stocks : int

var char_dist_x : float

func _physics_process(delta):
	char_dist_x = abs(player1.global_position.x - player2.global_position.x)
	
	stock_count()

func stock_count():
	if p1_stocks == 0 || p2_stocks == 0:
		game_set()

func game_set():
	print("game set")
