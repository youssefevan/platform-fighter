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
export var hitstun_node: NodePath
onready var hitstun: BaseState = get_node(hitstun_node)

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

export var knockback_modifier: float # higher make lighter characters; 100 default

export var port: int

var current_speed = run_speed
var jump_height
var fastfalling = false
#var can_attack

var air_jumps_remaining = air_jumps
var landing_lag: int = 4

var velocity = Vector2()

var got_hit = false
var percentage = 0

func _ready():
	states.init(self)
	jump_height = fullhop_height

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
	
	$Hitbox.scale.x = sprite_facing()
	
	print(got_hit)

func sprite_facing():
	if sprite.flip_h == true:
		return -1
	else:
		return 1

func get_attack():
	var attack
	
	var dir = Vector2()
	dir.x = Input.get_action_strength("right") - Input.get_action_strength("left")
	dir.y = Input.get_action_strength("down") - Input.get_action_strength("up")
	
	if dir == Vector2.ZERO:
		if is_on_floor() == true:
			attack = ground_neutral
		else:
			attack = aerial_neutral
	else:
		if dir.y < -.5:
			if is_on_floor() == true:
				attack = ground_up
			else:
				attack = aerial_up
		
		if dir.y > .5:
			if is_on_floor() == true:
				attack = ground_down
			else:
				
				attack = aerial_down
		
		if abs(dir.x) >= 0.5:
			if is_on_floor() == true:
				attack = ground_side
			else:
				attack = aerial_side
				if dir.x < 0:
					sprite.flip_h = true
				elif dir.x > 0:
					sprite.flip_h = false
		
	return attack

# bad
func _on_GroundNeutral_disable_hitbox():
	$Hitbox/Bounds.disabled = true

func _on_AerialSide_disable_hitbox():
	$Hitbox/Bounds.disabled = true

func _on_AerialNeutral_disable_hitbox():
	$Hitbox/Bounds.disabled = true

func _on_GroundSide_disable_hitbox():
	$Hitbox/Bounds.disabled = true

func _on_AerialUp_disable_hitbox():
	$Hitbox/Bounds.disabled = true

func _on_GroundDown_disable_hitbox():
	$Hitbox/Bounds.disabled = true

func _on_AerialDown_disable_hitbox():
	$Hitbox/Bounds.disabled = true

func _on_GroundUp_disable_hitbox():
	$Hitbox/Bounds.disabled = true

func _on_Hurtbox_hit_info(hit, kb_dir, kb_pow, d_percent):
	print("hurt")
	got_hit = true
