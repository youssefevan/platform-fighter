extends BaseState

var x_input
var shorthop
var frame

func enter():
	.enter()
	shorthop = false
	frame = 0

func physics_process(delta):
	move(delta)
	frame += 1
	
	char_base.velocity.y = 1 # keep in contact with ground
	char_base.velocity = char_base.move_and_slide(char_base.velocity, Vector2.UP)
	
	if char_base.just_input_jump:
		shorthop = true
		char_base.jump_height = char_base.shorthop_height
	
	if frame == char_base.jumpsquat_frames:
		return char_base.jump
		
	if char_base.got_hit == true:
		return char_base.hitstun

func move(delta):
	x_input = char_base.right - char_base.left
	
	if x_input != 0:
		char_base.velocity.x += char_base.ground_acceleration * x_input * delta
		char_base.velocity.x = clamp(char_base.velocity.x, -char_base.run_speed, char_base.run_speed)

func exit():
	.exit()
	frame = 0
