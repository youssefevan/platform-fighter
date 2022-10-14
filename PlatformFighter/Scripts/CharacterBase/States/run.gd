extends BaseState

var x_input = 0

func enter():
	.enter()
	#char_base.can_attack = true

func physics_process(delta):
	move(delta)
	
	char_base.velocity.y = 1
	char_base.velocity = char_base.move_and_slide(char_base.velocity, Vector2.UP)
	
	if x_input < 0:
		char_base.sprite.flip_h = true
	
	if x_input > 0:
		char_base.sprite.flip_h = false
	
	if x_input == 0:
		return char_base.idle
	
	if Input.is_action_just_pressed("jump"):
		return char_base.jumpsquat
		
	if char_base.is_grounded() == false:
		return char_base.fall
	
	if Input.is_action_just_pressed("attack"):
		char_base.get_attack_angle()
		return char_base.get_attack()

func move(delta):
	x_input = Input.get_action_strength("right") - Input.get_action_strength("left")
	
	if x_input != 0:
		char_base.velocity.x += char_base.ground_acceleration * x_input * delta
		char_base.velocity.x = clamp(char_base.velocity.x, -char_base.run_speed, char_base.run_speed)
