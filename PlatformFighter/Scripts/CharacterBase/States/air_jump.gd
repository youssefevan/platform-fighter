extends BaseState

var enter_x_input

func enter():
	.enter()
	#char_base.can_attack = true
	enter_x_input = Input.get_action_strength("right") - Input.get_action_strength("left")
	if enter_x_input != 0:
		char_base.velocity.x = char_base.air_speed * enter_x_input
	
	if char_base.air_jumps > 1:
		if enter_x_input < 0:
			char_base.sprite.flip_h = true
		if enter_x_input > 0:
			char_base.sprite.flip_h = false
	
	char_base.air_jumps_remaining -= 1
	char_base.velocity.y = 0
	char_base.velocity.y -= char_base.air_jump_height

func physics_process(delta):
	move(delta)
	
	char_base.velocity.y += char_base.gravity * delta
	
	char_base.velocity = char_base.move_and_slide(char_base.velocity, Vector2.UP)
	
	if char_base.velocity.y > 0:
		return char_base.fall
	
	if Input.is_action_just_pressed("jump") and char_base.air_jumps_remaining != 0:
		return char_base.air_jump
	
	if char_base.is_on_floor() == true:
		return char_base.land
	
	if Input.is_action_just_pressed("attack"):
		return char_base.get_attack()

func move(delta):
	var x_input = 0
	x_input = Input.get_action_strength("right") - Input.get_action_strength("left")
	
	if x_input != 0:
		char_base.velocity.x += char_base.air_acceleration * x_input * delta
		char_base.velocity.x = clamp(char_base.velocity.x, -char_base.current_speed, char_base.current_speed)
	else:
		char_base.velocity.x = lerp(char_base.velocity.x, 0, char_base.air_friction * delta)
