extends KinematicBody2D

var got_hit = false
var kb_direction
var kb_power
var kb_scaling
var damage_percent
var percentage = 0
var knockback_modifier = 100

var grav = 750

var velocity = Vector2.ZERO

func _ready():
	percentage = 0

func _physics_process(delta):
	#print(velocity)
	if got_hit == true:
		var knockback = ((((
			(percentage/10 + (percentage * damage_percent)/20)
			 * 200/(knockback_modifier+100) * 1.4)
			 + 18) * kb_scaling) + kb_power)
		velocity = kb_direction * knockback
		got_hit = false
	
	if !is_on_floor():
		velocity.y += grav * delta
	else:
		pass
	
	if is_on_floor():
		velocity.x = lerp(velocity.x, 0, 8 * delta)
	else:
		velocity.x = lerp(velocity.x, 0, 1 * delta)
	
	velocity = move_and_slide(velocity, Vector2.UP)


func _on_Hurtbox_hit_info(hit, kb_dir, kb_pow, d_percent, kb_scale):
	got_hit = hit
	kb_direction = kb_dir
	kb_power = kb_pow
	if kb_scale == -1:
		kb_scaling = 3.33
	else:
		kb_scaling = kb_scale
	damage_percent = d_percent
	percentage += damage_percent
	print(percentage, "%")
