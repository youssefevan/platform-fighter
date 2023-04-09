extends Node

var player1 : CharacterBase
var player2 : CharacterBase

var p1_stocks : int
var p2_stocks : int

var p1_char : String
var p2_char : String

var char_dist_x : float
var high_or_low: bool

var in_char_select: bool

func _ready():
	p1_stocks = 4
	p2_stocks = 4
	in_char_select = false

func _physics_process(delta):
	if player1 != null and player2 != null:
		char_dist_x = abs(player1.global_position.x - player2.global_position.x)
	
	stock_count()

func stock_count():
	if p1_stocks == 0 || p2_stocks == 0:
		game_set()

func game_set():
	print("game set")
