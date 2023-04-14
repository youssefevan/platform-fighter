extends Label

func _ready():
	if gm.game_set_type == 0:
		text = "Tie"
	elif gm.game_set_type == 1:
		text = "Player 1 wins!"
	elif gm.game_set_type == 2:
		text = "Player 2 wins!"
