extends Area2D

export var damage: float
export var kb_power: float
export var kb_angle: float

func get_kb_direction():
	var kb_angle_radians = deg2rad(kb_angle)
	var kb_x = cos(kb_angle_radians)
	var kb_y = sin(kb_angle_radians)
	var output = Vector2(kb_x, kb_y)
	
	return output
