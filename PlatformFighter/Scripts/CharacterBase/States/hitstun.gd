extends BaseState

var kb_direction
var kb_power
var damage_percent
var knockback_modifier = 100

var grav = 600

var velocity = Vector2.ZERO

func ready():
	var knockback = ((((
		(char_base.percentage/10 + (char_base.percentage * damage_percent)/20)
		* 200/(char_base.knockback_modifier+100) * 1.4)
		+ 18) * 1.33) + kb_power)
	char_base.velocity = kb_direction * knockback

func _physics_process(delta):
	pass
	#print(velocity)
	
#	if !char_base.is_on_floor():
#		velocity.y += grav * delta
#	else:
#		pass
#
#	if char_base.is_on_floor():
#		velocity.x = lerp(velocity.x, 0, 3 * delta)
#	else:
#		velocity.x = lerp(velocity.x, 0, 1 * delta)
#
#	velocity = move_and_slide(velocity, Vector2.UP)


func _on_Hurtbox_hit_info(hit, kb_dir, kb_pow, d_percent):
	#char_base.got_hit = hit
	kb_direction = kb_dir
	kb_power = kb_pow
	damage_percent = d_percent
	char_base.percentage += damage_percent
	print(char_base.percentage)
