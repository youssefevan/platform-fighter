extends KinematicBody2D
class_name CharacterBase

onready var shield_node = $Shield

onready var idle := $StateManager/Idle
onready var jump := $StateManager/Jump
onready var jumpsquat := $StateManager/Jumpsquat
onready var air_jump := $StateManager/AirJump
onready var fall := $StateManager/Fall
onready var run := $StateManager/Run
onready var land := $StateManager/Land
onready var freefall := $StateManager/Freefall
onready var hitstun := $StateManager/Hitstun
onready var shield := $StateManager/Shield
onready var drop_shield := $StateManager/DropShield
onready var respawn := $StateManager/Respawn

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

var hitstun_arc = preload("res://Scenes/Particles/HitstunArc.tscn")

var angel_platform : Node2D

export var gravity: float
export var fall_speed: float # default fallspeed
export var fastfall_speed: float # fallspeed when pressing down after apex
export var fastfall_gravity: float
export var fullhop_height: float # default grounded jump height; applied as force
export var shorthop_height: float # preformed if jump button is released during jumpsquate; applied as force
export var air_jump_height: float # height of aerial jumps; applied as force

export var run_speed: float 
export var ground_acceleration: float

export var speed_lerp: float = 5 # transition from ground to air speed

export var ground_friction: float # the rate at which a character slows while grounded
export var air_friction: float # the rate at which a character slows while airborne
export var air_acceleration: float
export var air_speed: float
export var air_jumps: int # some character may have more than one double jump
export var jumpsquat_frames: int
export var drop_shield_frames: int
export var shield_break_frames: int

export var weight := 1.0 # Recommended between 0.8 to 1.2; 1.0 default

export var port: int

var current_speed = run_speed
var jump_height
var fastfalling = false

var air_jumps_remaining = air_jumps
var landing_lag: int = 4

var shield_break := false

var velocity = Vector2()

var got_hit: bool = false
var percentage = 0

var up = 0
var down = 0
var left = 0
var right = 0

var horizontal_input = 0

var input_down = false
var input_jump = false
var input_attack = false
var input_special = false
var input_shield = false

var released_jump = false
var released_shield = false

var stocks
var respawning = false

func _ready():
	respawning = false
	stocks = 4
	if port == 1:
		$Tag.frame = 0
	elif port == 2:
		$Tag.frame = 1
	
	print("P", port, ": ", Input.get_joy_name(port))
	states.init(self)
	jump_height = fullhop_height
	shield_node.get_node("Collider").disabled = true
	
	if port == 1:
		gm.player1 = self
		gm.p1_stocks = 4
	elif port == 2:
		gm.player2 = self
		gm.p2_stocks = 4

func controls():
	if (port == 1 || port == 2):
		up = Input.get_action_strength("up_%s" % port)
		down = Input.get_action_strength("down_%s" % port)
		left = Input.get_action_strength("left_%s" % port)
		right = Input.get_action_strength("right_%s" % port)
		
		input_down = Input.is_action_just_pressed("down_%s" % port)
		input_shield = Input.is_action_pressed("shield_%s" % port)
		
		input_jump = Input.is_action_just_pressed("jump_%s" % port)
		input_attack = Input.is_action_just_pressed("attack_%s" % port)
		input_special = Input.is_action_just_pressed("special_%s" % port)
		
		released_jump = Input.is_action_just_released("jump_%s" % port)
		released_shield = Input.is_action_just_released("shield_%s" % port)

func _physics_process(delta):
	states.physics_process(delta)
	controls()
	
	if port == 1:
		gm.p1_percent = percentage
		gm.p1_stocks = stocks
	elif port == 2:
		gm.p2_percent = percentage
		gm.p2_stocks = stocks
	
	#print(Input.get_vector("right_1", "left_1", "down_1", "up_1", 0.2))
	
	if is_on_floor() == true:
		current_speed = lerp(current_speed, run_speed, speed_lerp * delta)
		fastfalling = false
	else:
		current_speed = lerp(current_speed, air_speed, speed_lerp * delta)
	
	if is_on_floor():
		air_jumps_remaining = air_jumps
	
	if velocity.y < 0:
		fastfalling = false

func sprite_facing():
	if sprite.flip_h == true:
		return -1
	else:
		return 1

func get_attack(type : int): # type = 0 -> normal attack, type = 1 -> special
	var attack
	
	var dir = Vector2()
	dir.x = right - left
	dir.y = down - up
	
	if type == 0: # normal attack
		if dir == Vector2.ZERO: # if neutral input
			if is_on_floor() == true: # if grounded
				attack = ground_neutral
			else:
				attack = aerial_neutral
		else:
			if abs(dir.x) > 0.5: # if side input
				if is_on_floor() == true: # if grounded
					attack = ground_side
				else:
					attack = aerial_side
					if dir.x < 0: # correct sprite orientation
						sprite.flip_h = true
					elif dir.x > 0:
						sprite.flip_h = false
			
			if dir.y <= -.5: # if up input
				if is_on_floor() == true: # if grounded
					attack = ground_up
				else:
					attack = aerial_up
			
			if dir.y >= .5: # if down input
				if is_on_floor() == true: # if grounded
					attack = ground_down
				else:
					attack = aerial_down
	
	if type == 1: # special attack
		if dir == Vector2.ZERO: # if neutral input
			attack = special_neutral
		
		else:
			if abs(dir.x) > 0.5: # if side inputz
				attack = special_side
					
				if dir.x < 0: # correct sprite orientation
					sprite.flip_h = true
				elif dir.x > 0:
					sprite.flip_h = false
			
			if dir.y <= -.5: # if up input
				attack = special_up
			
			if dir.y >= .5: # if down input
				attack = special_down
	
	if sprite_facing() == -1:
		$Hitbox.scale.x = -1
	else:
		$Hitbox.scale.x = 1
	
	return attack

func _on_Hurtbox_hit_info(hit, kb_dir, kb_pow, d_percent, kb_scale, hitbox_dir):
	#print("hurt")
	got_hit = true

func die():
	if respawning == false:
		if self == gm.player1:
			stocks -= 1
			percentage = 0
		if self == gm.player2:
			stocks -= 1
			percentage = 0
		respawning = true

func spawn_hitstun_arc():
	var arc = hitstun_arc.instance()
	#arc.global_position = global_position
	call_deferred("add_child", arc)
