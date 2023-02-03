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
	#move(delta)
	char_base.velocity.x = lerp(char_base.velocity.x, 0, char_base.ground_friction * delta) # slow to stop
	
	char_base.velocity.y = 1 # keep in contact with ground
	char_base.velocity = char_base.move_and_slide(char_base.velocity, Vector2.UP)
	
	if frame == land_frames:
		landing = false
	
	if char_base.got_hit == true:
		return char_base.hitstun
	
	if Input.is_action_just_pressed("jump"):
		jump_was_pressed = true
	
	if char_base.is_on_floor() == false:
		return char_base.fall
	
	if landing == false:
		if jump_was_pressed == true:
			return char_base.jumpsquat
		else:
			return char_base.idle

func move(delta):
	x_input = Input.get_action_strength("right") - Input.get_action_strength("left")
	
	if x_input != 0:
		char_base.velocity.x += char_base.ground_acceleration * x_input * delta
		char_base.velocity.x = clamp(char_base.velocity.x, -char_base.run_speed, char_base.run_speed)
