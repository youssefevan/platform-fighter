extends BaseState

signal disable_hitbox

export var attack_type: int # 0: grounded; 1: aerial; 2: special
export var landing_lag: int # how many frames of landing lag does this attack have
export var jump_cancellable: bool # attack can be exited with a jump

export var modify_velocity_x: int # 0 = no change; 1 = additive; 2 = set (linear)
export var modify_velocity_y: int # 0 = no change; 1 = additive; 2 = set (linear)

export var velocity_x: float # amount of change to x vel per frame
export var velocity_y: float # amount of change to y vel per frame

export var x_frames: int # number of frames x vel is modified
export var y_frames: int # number of frames y vel is modified

export var x_starting_velocity := -1.0 # -1 for no change
export var y_starting_velocity := -1.0 # -1 for no change

export var x_starting_frame: int
export var y_starting_frame: int


export var freefall: bool

var attacking: bool
var frame: int = 0

func anim_finished(anim_name):
	attacking = false

func anim_started(anim_name):
	attacking = true

func enter():
	.enter()
	connect_anims()
	frame = 0
	char_base.landing_lag = landing_lag
	attacking = true
	
	if x_starting_velocity == -1.0:
		char_base.velocity.x = char_base.velocity.x
	else:
		char_base.velocity.x = x_starting_velocity
	
	if y_starting_velocity == -1.0:
		char_base.velocity.y = char_base.velocity.y
	else:
		char_base.velocity.y = y_starting_velocity

func physics_process(delta):
	frame += 1
	
	if char_base.got_hit == true:
		return char_base.hitstun
	
	if char_base.is_on_floor() == true:
		if attack_type == 0 || attack_type == 2:
			grounded_attack(delta)
		
		if attacking == false:
			return char_base.idle
			
		if attack_type == 1: # if attack type is aerial
			return char_base.land
	
	if char_base.is_on_floor() == false:
		if attack_type == 1 || attack_type == 2:
			aerial_attack(delta)
		
		if attacking == false:
			if freefall == false:
				return char_base.fall
			else:
				return char_base.freefall
		
		if attack_type == 0: # if attack type is grounded
			return char_base.fall
	
	if jump_cancellable == true:
		if Input.is_action_just_pressed("jump"):
			if char_base.is_on_floor() == true:
				return char_base.jumpsquat
			elif char_base.is_on_floor() == false and char_base.air_jumps_remaining != 0:
				return char_base.air_jump
	
	char_base.velocity = char_base.move_and_slide(char_base.velocity, Vector2.UP)

func grounded_attack(delta):
	match(modify_velocity_x):
		0: # none
			char_base.velocity.x = lerp(char_base.velocity.x, 0, char_base.ground_friction * delta) # slow to stop
		1: # additive
			if frame >= x_starting_frame and frame <= x_frames + x_starting_frame:
				char_base.velocity.x += velocity_x * char_base.sprite_facing()
			else:
				char_base.velocity.x = lerp(char_base.velocity.x, 0, char_base.ground_friction * delta) # slow to stop
		2: # set
			if frame >= x_starting_frame and frame <= x_frames + x_starting_frame:
				char_base.velocity.x = velocity_x * char_base.sprite_facing()
			else:
				char_base.velocity.x = lerp(char_base.velocity.x, 0, char_base.ground_friction * delta) # slow to stop
	
	match(modify_velocity_y):
		0: # none
			char_base.velocity.y = 1 # keep grounded
		1: # additive
			if frame >= y_starting_frame and frame <= y_frames + y_starting_frame:
				char_base.velocity.y += velocity_y
			else:
				char_base.velocity.y = 1 # keep grounded
		2: # set
			if frame >= y_starting_frame and frame <= y_frames + y_starting_frame:
				char_base.velocity.y = velocity_y
			else:
				char_base.velocity.y = 1 # keep grounded

func aerial_attack(delta):
	match(modify_velocity_x):
		0: # none
			air_movement_x(delta)
		1: # additive
			if frame >= x_starting_frame and frame <= x_frames + x_starting_frame:
				char_base.velocity.x += velocity_x * char_base.sprite_facing()
			else:
				air_movement_x(delta)
		2: # set
			if frame >= x_starting_frame and frame <= x_frames + x_starting_frame:
				char_base.velocity.x = velocity_x * char_base.sprite_facing()
			else:
				air_movement_x(delta)
	
	match(modify_velocity_y):
		0: # none
			air_movement_y(delta)
		1: # additive
			if frame >= y_starting_frame and frame <= y_frames + y_starting_frame:
				char_base.velocity.y += velocity_y
			else:
				air_movement_y(delta)
		2: # set
			if frame >= y_starting_frame and frame <= y_frames + y_starting_frame:
				char_base.velocity.y = velocity_y
			else:
				air_movement_y(delta)

func air_movement_x(delta):
	var x_input = 0
	x_input = Input.get_action_strength("right") - Input.get_action_strength("left")
	
	if x_input != 0:
		char_base.velocity.x += char_base.air_acceleration * x_input * delta
		char_base.velocity.x = clamp(char_base.velocity.x, -char_base.current_speed, char_base.current_speed)
	else:
		char_base.velocity.x = lerp(char_base.velocity.x, 0, char_base.air_friction * delta)

func air_movement_y(delta):
	fastfalling_check()
	
	if char_base.fastfalling == true:
		char_base.velocity.y += char_base.gravity * char_base.fastfall_gravity * delta
		
		if char_base.velocity.y > char_base.fastfall_speed:
			char_base.velocity.y = char_base.fastfall_speed
	else:
		char_base.velocity.y += char_base.gravity * delta
		
		if char_base.velocity.y > char_base.fall_speed:
			char_base.velocity.y = char_base.fall_speed

func fastfalling_check():
	if Input.is_action_just_pressed("down") and frame > y_frames:
		char_base.fastfalling = true

func exit():
	.exit()
	char_base.hitbox.disabled = true
	#emit_signal("disable_hitbox")
