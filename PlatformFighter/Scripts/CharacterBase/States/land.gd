extends BaseState

var landing = false
var x_input
var jump_was_pressed

var frame: int
var land_frames: int

func enter():
	.enter()
	jump_was_pressed = false
	frame = 0
	landing = true
	land_frames = char_base.landing_lag

func physics_process(delta):
	frame += 1
	
	char_base.velocity.x = lerp(char_base.velocity.x, 0, char_base.ground_friction * delta) # slow to stop
	
	char_base.velocity.y = 1 # keep in contact with ground
	char_base.velocity = char_base.move_and_slide(char_base.velocity, Vector2.UP)
	
	if frame == land_frames:
		landing = false
	
	if char_base.got_hit == true:
		return char_base.hitstun
	
	if char_base.input_jump:
		jump_was_pressed = true
	
	if char_base.is_on_floor() == false:
		return char_base.fall
	
	if landing == false:
		if jump_was_pressed == true:
			return char_base.jumpsquat
		else:
			return char_base.idle
