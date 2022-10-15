extends BaseState

var fastfalling = false

func enter():
	.enter()
	#char_base.can_attack = false

func physics_process(delta):
	moving(delta)
	fastfalling_check()
	
	if fastfalling == true:
		char_base.velocity.y += char_base.gravity * char_base.fastfall_gravity * delta
		
		if char_base.velocity.y > char_base.fastfall_speed:
			char_base.velocity.y = char_base.fastfall_speed
	else:
		char_base.velocity.y += char_base.gravity * delta
		
		if char_base.velocity.y > char_base.fall_speed:
			char_base.velocity.y = char_base.fall_speed
	
	char_base.velocity = char_base.move_and_slide(char_base.velocity, Vector2.UP)
	
	if char_base.is_on_floor() == true:
		fastfalling = false
		return char_base.land
	

func fastfalling_check():
	if Input.is_action_just_pressed("down"):
		fastfalling = true
	

func moving(delta):
	var x_input = 0
	x_input = Input.get_action_strength("right") - Input.get_action_strength("left")
	
	if x_input != 0:
		char_base.velocity.x += char_base.air_acceleration * x_input * delta
		char_base.velocity.x = clamp(char_base.velocity.x, -char_base.current_speed, char_base.current_speed)
	else:
		char_base.velocity.x = lerp(char_base.velocity.x, 0, char_base.air_friction * delta)

func exit():
	.exit()
	fastfalling = false
