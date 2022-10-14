extends BaseState

export var attack_type: int # 0: grounded; 1: aerial; 2: hybrid (transistion between either)
export var landing_lag: int # how many frames of landing lag does this attack have
export var l_cancellable: bool

export var modify_velocity_x: bool
export var modify_velocity_y: bool

export var velocity_x: float
export var velocity_y: float

export var velocity_x_frame: int
export var velocity_y_frame: int

var attacking: bool
var frame: int = 0
var l_cancel_input: int

func anim_finished(anim_name):
	attacking = false

func anim_started(anim_name):
	attacking = true

func enter():
	.enter()
	connect_anims()
	frame = 0
	char_base.landing_lag = landing_lag
	l_cancel_input = 8
	char_base.l_cancelled = false
	attacking = true

func physics_process(delta):
	frame += 1
	
	if char_base.is_grounded() == true:
		if attacking == false:
			return char_base.idle
			
		if attack_type == 1: # if attack type is aerial
			return char_base.land
			
		grounded_attack(delta)
	
	if char_base.is_grounded() == false:
		
		if attacking == false:
			return char_base.fall
		
		if attack_type == 0: # if attack type is grounded
			return char_base.fall
		
		aerial_attack(delta)
	
	char_base.velocity = char_base.move_and_slide(char_base.velocity, Vector2.UP)

func grounded_attack(delta):
	
	if modify_velocity_x == true and frame == velocity_x_frame:
		char_base.velocity.x += velocity_x * char_base.sprite_facing()
	else:
		char_base.velocity.x = lerp(char_base.velocity.x, 0, char_base.ground_friction * delta) # slow to stop
	
	if modify_velocity_y == true and frame == velocity_y_frame:
		char_base.velocity.y += velocity_y
	else:
		char_base.velocity.y = 1 # keep in contact with ground

func aerial_attack(delta):
	
	l_cancel(delta)
	
	if modify_velocity_x == true and frame == velocity_x_frame:
		char_base.velocity.x = velocity_x * char_base.sprite_facing()
	else:
		air_movement_x(delta)
	
	if modify_velocity_y == true and frame == velocity_y_frame:
		char_base.velocity.y = velocity_y
	else:
		air_movement_y(delta) # keep in contact with ground

func l_cancel(delta):
	if Input.is_action_just_pressed("airdodge"):
		l_cancel_input = frame

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
	if Input.is_action_just_pressed("down"):
		char_base.fastfalling = true

func exit():
	.exit()
	var check_l_cancel = frame - l_cancel_input
	#print(check_l_cancel)
	
	if check_l_cancel <= 7:
		if l_cancellable == true:
			char_base.l_cancelled = true
			#print("l cancel")
