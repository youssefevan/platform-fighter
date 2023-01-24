extends KinematicBody2D

var got_hit = false
var kb_direction
var kb_power
var damage_percent
var percentage = 0
var knockback_modifier = 100

var grav = 300

var velocity = Vector2.ZERO

func _ready():
	percentage = 0

func _physics_process(delta):
	#print(velocity)
	if got_hit == true:
		var knockback = ((((
			(percentage/10 + (percentage * damage_percent)/20)
			 * 200/(knockback_modifier+100) * 1.4)
			 + 18) * 1.33) + kb_power)
		velocity = kb_direction * knockback
		got_hit = false
	
	if !is_on_floor():
		velocity.y += grav * delta
	else:
		pass
	
	if is_on_floor():
		velocity.x = lerp(velocity.x, 0, 3 * delta)
	else:
		velocity.x = lerp(velocity.x, 0, 1 * delta)
	
	velocity = move_and_slide(velocity, Vector2.UP)


func _on_Hurtbox_hit_info(hit, kb_dir, kb_pow, d_percent):
	got_hit = hit
	kb_direction = kb_dir
	kb_power = kb_pow
	damage_percent = d_percent
	percentage += damage_percent
	print(percentage, "%")
