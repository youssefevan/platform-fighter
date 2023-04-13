extends BaseState

var enter_x_input
var enter_attack
var enter_special

func enter():
	.enter()
	
	enter_x_input = char_base.right - char_base.left
	char_base.velocity.x = char_base.air_speed * enter_x_input
	
	if char_base.air_jumps > 1:
		if enter_x_input < 0:
			char_base.sprite.flip_h = true
		if enter_x_input > 0:
			char_base.sprite.flip_h = false
	
	char_base.air_jumps_remaining -= 1
	char_base.velocity.y = 0
	char_base.velocity.y -= char_base.air_jump_height
	
	# entering inputs
	if char_base.input_attack:
		enter_attack = true
		#print("AIR_JUMP --> enter_attack")
	if char_base.input_special:
		enter_special = true
		#print("AIR_JUMP --> enter_special")

func physics_process(delta):
	horizontal_movement(delta)
	
	char_base.velocity.y += char_base.gravity * delta
	
	char_base.velocity = char_base.move_and_slide(char_base.velocity, Vector2.UP)
	
	# State Changes
	if char_base.got_hit == true:
		return char_base.hitstun
	
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
	
	if char_base.respawning == true:
		return char_base.respawn

func horizontal_movement(delta):
	var x_input = 0
	x_input = char_base.right - char_base.left
	
	if x_input != 0:
		char_base.velocity.x += char_base.air_acceleration * x_input * delta
		char_base.velocity.x = clamp(char_base.velocity.x, -char_base.current_speed, char_base.current_speed)
	else:
		char_base.velocity.x = lerp(char_base.velocity.x, 0, char_base.air_friction * delta)

func exit():
	.exit()
	enter_attack = false
	enter_special = false
