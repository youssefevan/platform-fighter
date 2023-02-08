extends BaseState

var enter_attack
var enter_special

func enter():
	.enter()
	#char_base.can_attack = true
	char_base.velocity.y -= char_base.jump_height
	
	# entering inputs
	if char_base.input_attack:
		enter_attack = true
		#print("JUMP --> enter_attack")
	if char_base.input_special:
		enter_special = true
		#print("JUMP --> enter_special")

func physics_process(delta):
	move(delta)
	
	if char_base.got_hit == true:
		return char_base.hitstun
	
	char_base.velocity.y += char_base.gravity * delta
	
	char_base.velocity = char_base.move_and_slide(char_base.velocity, Vector2.UP)
	
	if char_base.velocity.y > 0:
		return char_base.fall
	
	if char_base.input_jump and char_base.air_jumps_remaining != 0:
		return char_base.air_jump
	
	if char_base.is_on_floor() == true:
		return char_base.land
	
	# Attacking
	if enter_attack == true:
		return char_base.get_attack(0)
	
	if enter_special == true:
		return char_base.get_attack(1)
	
	if char_base.input_attack:
		return char_base.get_attack(0)
	
	if char_base.input_special:
		return char_base.get_attack(1)

func move(delta):
	var x_input = 0
	x_input = char_base.right - char_base.left
	
	if x_input != 0:
		char_base.velocity.x += char_base.air_acceleration * x_input * delta
		char_base.velocity.x = clamp(char_base.velocity.x, -char_base.current_speed, char_base.current_speed)
	else:
		char_base.velocity.x = lerp(char_base.velocity.x, 0, char_base.air_friction * delta)

func exit():
	.exit()
	char_base.jump_height = char_base.fullhop_height
	
	enter_attack = false
	enter_special = false
