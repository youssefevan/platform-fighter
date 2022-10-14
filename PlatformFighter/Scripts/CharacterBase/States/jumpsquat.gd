extends BaseState

#var jumpsquatting = false
var x_input
var shorthop
var frame

func enter():
	.enter()
	#connect_anims()
	#char_base.can_attack = false
	shorthop = false
	frame = 0

func physics_process(delta):
	move(delta)
	frame += 1
	#char_base.velocity.x = lerp(char_base.velocity.x, 0, char_base.ground_friction * delta) # slow to stop
	
	char_base.velocity.y = 1 # keep in contact with ground
	char_base.velocity = char_base.move_and_slide(char_base.velocity, Vector2.UP)
	
#	if jumpsquatting == true:
	if Input.is_action_just_released("jump"):
		shorthop = true
		char_base.jump_height = char_base.shorthop_height
	
	if frame == char_base.jumpsquat_frames:
		return char_base.jump
	
#	if jumpsquatting == false:
#		return char_base.jump

#func anim_started(anim_name):
#	if anim_name == "Jumpsquat":
#		jumpsquatting = true
#
#func anim_finished(anim_name):
#	if anim_name == "Jumpsquat":
#		jumpsquatting = false

func move(delta):
	x_input = Input.get_action_strength("right") - Input.get_action_strength("left")
	
	if x_input != 0:
		char_base.velocity.x += char_base.ground_acceleration * x_input * delta
		char_base.velocity.x = clamp(char_base.velocity.x, -char_base.run_speed, char_base.run_speed)

func exit():
	.exit()
	frame = 0
