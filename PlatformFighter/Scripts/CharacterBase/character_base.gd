extends KinematicBody2D
class_name CharacterBase

onready var idle := $StateManager/Idle
onready var jump := $StateManager/Jump
onready var jumpsquat := $StateManager/Jumpsquat
onready var air_jump := $StateManager/AirJump
onready var fall := $StateManager/Fall
onready var run := $StateManager/Run
onready var land := $StateManager/Land
onready var freefall := $StateManager/Freefall
onready var hitstun := $StateManager/Hitstun

# ground attacks
export var ground_neutral_node: NodePath
onready var ground_neutral: BaseState = get_node(ground_neutral_node)
export var ground_side_node: NodePath
onready var ground_side: BaseState = get_node(ground_side_node)
export var ground_up_node: NodePath
onready var ground_up: BaseState = get_node(ground_up_node)
export var ground_down_node: NodePath
onready var ground_down: BaseState = get_node(ground_down_node)

# air attacks
export var aerial_neutral_node: NodePath
onready var aerial_neutral: BaseState = get_node(aerial_neutral_node)
export var aerial_up_node: NodePath
onready var aerial_up: BaseState = get_node(aerial_up_node)
export var aerial_side_node: NodePath
onready var aerial_side: BaseState = get_node(aerial_side_node)
export var aerial_down_node: NodePath
onready var aerial_down: BaseState = get_node(aerial_down_node)

# special attacks
export var special_neutral_node: NodePath
onready var special_neutral: BaseState = get_node(special_neutral_node)
export var special_up_node: NodePath
onready var special_up: BaseState = get_node(special_up_node)
export var special_side_node: NodePath
onready var special_side: BaseState = get_node(special_side_node)
export var special_down_node: NodePath
onready var special_down: BaseState = get_node(special_down_node)

onready var states = $StateManager
onready var animations = $Animator
onready var sprite = $Sprite
onready var hitbox = $Hitbox/Bounds

export var gravity: float
export var fall_speed: float # default fallspeed
export var fastfall_speed: float # fallspeed when pressing down after apex
export var fastfall_gravity: float
export var fullhop_height: float # default grounded jump height; applied as force
export var shorthop_height: float # preformed if jump button is released during jumpsquate; applied as force
export var air_jump_height: float # height of aerial jumps; applied as force

export var run_speed: float 
export var ground_acceleration: float

export var speed_lerp: float = 5

export var ground_friction: float # the rate at which a character slows while grounded
export var air_friction: float # the rate at which a character slows while airborne
export var air_acceleration: float
export var air_speed: float
export var air_jumps: int # some character may have more than one double jump
export var jumpsquat_frames: int

export var weight: float # higher make lighter characters; 100 default # modifies kb

export var port: int

var current_speed = run_speed
var jump_height
var fastfalling = false
#var can_attack

var air_jumps_remaining = air_jumps
var landing_lag: int = 4

var velocity = Vector2()

var got_hit: bool = false
var percentage = 0

func _ready():
	states.init(self)
	jump_height = fullhop_height
	#init_controls()

func init_controls():
	var left = Input.get_joy_axis(port, 0)
	var jump = Input.is_joy_button_pressed(port, 2)

func _physics_process(delta):
	states.physics_process(delta)
	if is_on_floor() == true:
		current_speed = lerp(current_speed, run_speed, speed_lerp * delta)
		fastfalling = false
	else:
		current_speed = lerp(current_speed, air_speed, speed_lerp * delta)
	
	if is_on_floor():
		air_jumps_remaining = air_jumps
	
	if velocity.y < 0:
		fastfalling = false
	
	#print(got_hit)

func sprite_facing():
	if sprite.flip_h == true:
		return -1
	else:
		return 1

func get_attack(type : int): # type = 0 -> normal attack, type = 1 -> special
	var attack
	
	var dir = Vector2()
	dir.x = Input.get_action_strength("right") - Input.get_action_strength("left")
	dir.y = Input.get_action_strength("down") - Input.get_action_strength("up")
	
	if type == 0: # normal attack
		if dir == Vector2.ZERO: # if neutral input
			if is_on_floor() == true: # if grounded
				attack = ground_neutral
			else:
				attack = aerial_neutral
		else:
			if dir.y < -.5: # if up input
				if is_on_floor() == true: # if grounded
					attack = ground_up
				else:
					attack = aerial_up
			
			if dir.y > .5: # if down input
				if is_on_floor() == true: # if grounded
					attack = ground_down
				else:
					attack = aerial_down
			
			if abs(dir.x) >= 0.5: # if side input
				if is_on_floor() == true: # if grounded
					attack = ground_side
				else:
					attack = aerial_side
					if dir.x < 0: # correct sprite orientation
						sprite.flip_h = true
					elif dir.x > 0:
						sprite.flip_h = false
	
	if type == 1: # special attack
		if dir == Vector2.ZERO: # if neutral input
			attack = special_neutral
		
		else:
			if dir.y < -.5: # if up input
				attack = special_up
			
			if dir.y > .5: # if down input
				attack = special_down
			
			if abs(dir.x) >= 0.5: # if side inputz
				attack = special_side
					
				if dir.x < 0: # correct sprite orientation
					sprite.flip_h = true
				elif dir.x > 0:
					sprite.flip_h = false
	
	if sprite_facing() == -1:
		$Hitbox.scale.x = -1
	else:
		$Hitbox.scale.x = 1
	
	return attack

func _on_Hurtbox_hit_info(hit, kb_dir, kb_pow, d_percent, kb_scale):
	#print("hurt")
	got_hit = true
