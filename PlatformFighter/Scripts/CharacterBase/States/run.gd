extends BaseState

var x_input = 0
var enter_jump
var enter_attack
var enter_special

func enter():
	.enter()
	
	# entering inputs
	if Input.is_action_just_pressed("jump") == true:
		enter_jump = true
		#print("RUN --> enter_jump")
	if Input.is_action_just_pressed("attack") == true:
		enter_attack = true
		#print("RUN --> enter_attack")
	if Input.is_action_just_pressed("special") == true:
		enter_special = true
		#print("RUN --> enter_special")

func physics_process(delta):
	move(delta)
	
	if char_base.got_hit == true:
		return char_base.hitstun
	
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
		
	if char_base.is_on_floor() == false:
		return char_base.fall
	
	if enter_jump == true:
		return char_base.jumpsquat
	
	if enter_attack == true:
		return char_base.get_attack(0)
	
	if enter_special == true:
		return char_base.get_attack(1)
	
	if Input.is_action_just_pressed("attack"):
		return char_base.get_attack(0)
		
	if Input.is_action_just_pressed("special"):
		return char_base.get_attack(1)

func move(delta):
	x_input = Input.get_action_strength("right") - Input.get_action_strength("left")
	
	if x_input != 0:
		char_base.velocity.x += char_base.ground_acceleration * x_input * delta
		char_base.velocity.x = clamp(char_base.velocity.x, -char_base.run_speed, char_base.run_speed)

func exit():
	.exit()
	enter_jump = false
	enter_attack = false
	enter_special = false
