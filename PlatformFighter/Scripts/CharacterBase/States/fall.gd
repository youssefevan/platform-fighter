extends BaseState

var enter_air_jump = false
var enter_attack = false
var enter_special = false

func enter():
	.enter()
	
	if Input.is_action_just_pressed("jump") == true:
		if char_base.air_jumps_remaining != 0:
			enter_air_jump = true
	if Input.is_action_just_pressed("attack") == true:
		enter_attack = true
	if Input.is_action_just_pressed("special") == true:
		enter_special = true

func physics_process(delta):
	move(delta)
	#char_base.can_attack = true
	fastfalling_check()
	
	if enter_air_jump == true:
		return char_base.air_jump
	
	if enter_attack == true:
		return char_base.get_attack(0)
	
	if enter_special == true:
		return char_base.get_attack(1)
	
	if char_base.velocity.y < 0:
		char_base.velocity.y += char_base.gravity * delta
	else:
		if char_base.fastfalling == true:
			char_base.velocity.y += char_base.gravity * char_base.fastfall_gravity * delta
			
			if char_base.velocity.y > char_base.fastfall_speed:
				char_base.velocity.y = char_base.fastfall_speed
		else:
			char_base.velocity.y += char_base.gravity * delta
			
			if char_base.velocity.y > char_base.fall_speed:
				char_base.velocity.y = char_base.fall_speed
	
	char_base.velocity = char_base.move_and_slide(char_base.velocity, Vector2.UP)
	
	if char_base.is_on_floor() == true:
		char_base.fastfalling = false
		return char_base.idle
	
	if char_base.got_hit == true:
		return char_base.hitstun
	
	if Input.is_action_just_pressed("jump") and char_base.air_jumps_remaining != 0:
		return char_base.air_jump
	
	if Input.is_action_just_pressed("attack"):
		return char_base.get_attack(0)
	
	if Input.is_action_just_pressed("special"):
		return char_base.get_attack(1)

func fastfalling_check():
	if Input.is_action_just_pressed("down"):
		char_base.fastfalling = true

func move(delta):
	var x_input = 0
	x_input = Input.get_action_strength("right") - Input.get_action_strength("left")
	
	if x_input != 0:
		char_base.velocity.x += char_base.air_acceleration * x_input * delta
		char_base.velocity.x = clamp(char_base.velocity.x, -char_base.current_speed, char_base.current_speed)
	else:
		char_base.velocity.x = lerp(char_base.velocity.x, 0, char_base.air_friction * delta)

func exit():
	.exit()
	enter_air_jump = false
	enter_attack = false
