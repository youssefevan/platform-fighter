extends Node

func button_just_pressed(port: int, action: String):
#	if Input.is_joy_known(port):
#		if Input.is_action_just_pressed(action):
#			return true
#		else:
#			return false
#	else:
#		return false
	
	if Input.is_action_just_pressed(action):
		return true
	else:
		return false
