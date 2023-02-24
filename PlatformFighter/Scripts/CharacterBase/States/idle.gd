extends BaseState

var enter_x_input
var enter_jump
var enter_attack
var enter_special

func enter():
	.enter()
	enter_x_input = char_base.right - char_base.left
	
	# entering inputs
	if char_base.input_jump:
		enter_jump = true
		#print("IDLE --> enter_jump")
	if char_base.input_attack:
		enter_attack = true
		#print("IDLE --> enter_attack")
	if char_base.input_special:
		enter_special = true
		#print("IDLE --> enter_special")

func physics_process(delta):
	var x_input = char_base.right - char_base.left
	
	char_base.velocity.x = lerp(char_base.velocity.x, 0, char_base.ground_friction * delta) # slow to stop
	
	char_base.velocity.y = 1 # keep in contact with ground
	char_base.velocity = char_base.move_and_slide(char_base.velocity, Vector2.UP)
	
	if x_input < 0:
		char_base.sprite.flip_h = true
	
	if x_input > 0:
		char_base.sprite.flip_h = false
	
	if char_base.got_hit == true:
		return char_base.hitstun
	
	if char_base.is_on_floor() == false:
		return char_base.fall
	
	if char_base.input_jump:
		return char_base.jumpsquat
	
	if x_input != 0:
		return char_base.run
	
	if enter_jump == true:
		return char_base.jumpsquat
	
	# Attacking
	if enter_attack == true:
		return char_base.get_attack(0)
	
	if enter_special == true:
		return char_base.get_attack(1)
	
	if char_base.input_attack:
		return char_base.get_attack(0)
	
	if char_base.input_special:
		return char_base.get_attack(1)
	
	if char_base.input_shield:
		return char_base.shield

func exit():
	.exit()
	enter_jump = false
	enter_special = false
	enter_attack = false
