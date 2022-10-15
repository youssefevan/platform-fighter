extends KinematicBody2D
class_name CharacterBase

export var idle_node: NodePath
onready var idle: BaseState = get_node(idle_node)
export var jump_node: NodePath
onready var jump: BaseState = get_node(jump_node)
export var jumpsquat_node: NodePath
onready var jumpsquat: BaseState = get_node(jumpsquat_node)
export var air_jump_node: NodePath
onready var air_jump: BaseState = get_node(air_jump_node)
export var fall_node: NodePath
onready var fall: BaseState = get_node(fall_node)
export var run_node: NodePath
onready var run: BaseState = get_node(run_node)
export var land_node: NodePath
onready var land: BaseState = get_node(land_node)
export var freefall_node: NodePath
onready var freefall: BaseState = get_node(freefall_node)

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

onready var states = $StateManager
onready var animations = $Animator
onready var sprite = $Sprite

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

export var knockback_modifier: float # between 0 and 1; multiplied to knockback; higher make lighter characters

export var port: int

var current_speed = run_speed
var jump_height
var fastfalling = false
#var can_attack

var air_jumps_remaining = air_jumps
var landing_lag: int = 4

var velocity = Vector2()

func _ready():
	states.init(self)
	jump_height = fullhop_height

func _physics_process(delta):
	states.physics_process(delta)
	is_grounded()
	#get_attack_angle()
	#get_attack()
	
	if is_grounded() == true:
		current_speed = lerp(current_speed, run_speed, speed_lerp * delta)
		fastfalling = false
	else:
		current_speed = lerp(current_speed, air_speed, speed_lerp * delta)
	
	if is_grounded():
		air_jumps_remaining = air_jumps
	
	if velocity.y < 0:
		fastfalling = false

func sprite_facing():
	if sprite.flip_h == true:
		return -1
	else:
		return 1

func is_grounded():
	if is_on_floor() == true:
		return true
	else:
		return false

#func get_attack_angle():
#	var direction = Vector2(Input.get_joy_axis(0, JOY_AXIS_0), Input.get_joy_axis(0, JOY_AXIS_1))
#	var angle = direction.angle()
#
#	angle = rad2deg(angle)
#
#	return angle

#func get_attack():
#	var attack
#	var input: Vector2
#
#	input.x = Input.get_action_strength("right") - Input.get_action_strength("left")
#	input.y = Input.get_action_strength("down") - Input.get_action_strength("up")
#
#	if input == Vector2.ZERO:
#		if is_grounded() == true:
#			attack = ground_attack_neutral
#		else:
#			attack = aerial_attack_neutral
#	else:
#
#		if get_attack_angle() > -135 and get_attack_angle() < -45:
#			if is_grounded() == true:
#				attack = ground_attack_up
#			else:
#				attack = aerial_attack_up
#
#		if get_attack_angle() > 45 and get_attack_angle() < 135:
#			if is_grounded() == true:
#				attack = ground_attack_down
#			else:
#				attack = aerial_attack_down
#
#		if get_attack_angle() >= -180 and get_attack_angle() <= -135:
#			if is_grounded() == true:
#				attack = ground_attack_side
#			else:
#				if sprite_facing() == -1:
#					attack = aerial_attack_forward
#				else:
#					attack = aerial_attack_back
#
#		if get_attack_angle() <= 180 and get_attack_angle() >= 135:
#			if is_grounded() == true:
#				attack = ground_attack_side
#			else:
#				if sprite_facing() == -1:
#					attack = aerial_attack_forward
#				else:
#					attack = aerial_attack_back
#
#		if get_attack_angle() >= -45 and get_attack_angle() <= 45:
#			if is_grounded() == true:
#				attack = ground_attack_side
#			else:
#				if sprite_facing() == -1:
#					attack = aerial_attack_back
#				else:
#					attack = aerial_attack_forward
#
#	#print(attack)
#
#	return attack
