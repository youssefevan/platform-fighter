extends Node

var player1 : CharacterBase
var player2 : CharacterBase

var p1_stocks : int
var p2_stocks : int

var p1_char : String
var p2_char : String

var p1_percent : int
var p2_percent : int

var char_dist_x : float
var high_or_low : bool

var in_char_select : bool

var angel_platform_position
var game_set_type # 0 tie # p1 # p2

func _ready():
	p1_stocks = 4
	p2_stocks = 4
	in_char_select = false

func _physics_process(delta):
	if player1 != null and player2 != null:
		if p1_stocks != 0 and p2_stocks != 0:
			char_dist_x = abs(player1.global_position.x - player2.global_position.x)
	
	stock_count()

func stock_count():
	if p1_stocks == 0 || p2_stocks == 0:
		if p1_stocks == 0 and p2_stocks == 0:
			game_set(0)
		elif p1_stocks == 0 and p2_stocks != 0:
			game_set(1)
		elif p2_stocks == 0 and p1_stocks != 0:
			game_set(2)

func game_set(winner: int):
	game_set_type = winner
	get_tree().change_scene("res://Scenes/GameSet.tscn")
