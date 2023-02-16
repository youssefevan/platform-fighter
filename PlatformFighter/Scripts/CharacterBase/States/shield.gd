extends BaseState

var enter_jump

func enter():
	.enter()
	if char_base.input_jump:
		enter_jump = true
	
	char_base.shield_node.visible = true
	char_base.shield_node.scale = Vector2(1, 1)

func physics_process(delta):
	
	char_base.velocity.x = lerp(char_base.velocity.x, 0, char_base.ground_friction * delta) # slow to stop
	
	char_base.velocity.y = 1 # keep in contact with ground
	char_base.velocity = char_base.move_and_slide(char_base.velocity, Vector2.UP)
	
	# State Changes
	if char_base.is_on_floor() == false:
		return char_base.idle
	
	if char_base.released_shield == true:
		return char_base.idle
	
	if char_base.input_jump == true or enter_jump == true:
		return char_base.jumpsquat

func exit():
	.exit()
	char_base.shield_node.visible = false
