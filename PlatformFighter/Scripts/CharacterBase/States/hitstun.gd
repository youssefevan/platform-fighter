extends BaseState

var kb_direction
var kb_power
var damage_percent
var knockback_modifier = 100
var kb_scaling
var default_kb_scaling = 3

var frame = 0

var hitstun_length

func enter():
	.enter()
	frame = 0
	char_base.got_hit = false
	
#	var old_knockback = ((((
#		(char_base.percentage/10 + (char_base.percentage * damage_percent)/20)
#		* 200/(char_base.knockback_modifier+100) * 1.4)
#		+ 18) * kb_scaling) + kb_power)
	
	var knockback = (
		(3 * (
		(damage_percent * (kb_scaling + char_base.percentage) / 20))
		* (2 / (1 + char_base.weight)) + 18) + kb_power)
	
	char_base.velocity = kb_direction * knockback
	
	#print("Hitstun Length: ", hitstun_length)

func physics_process(delta):
	frame += 1
	#print("Hitstun Frame: ", frame)
	
	if frame == hitstun_length:
		#print("exit")
		if char_base.is_on_floor() == true:
			return char_base.idle
		else:
			return char_base.fall
	
	#print(velocity)
	
	if char_base.got_hit == true:
		return char_base.hitstun
	
	if char_base.is_on_floor() == false:
		char_base.velocity.y += char_base.gravity * delta
		
		if char_base.velocity.y > char_base.fall_speed:
			char_base.velocity.y = char_base.fall_speed
		
	else:
		if frame > 1:
			return char_base.idle
		else:
			pass

	if char_base.is_on_floor() == true:
		char_base.velocity.x = lerp(char_base.velocity.x, 0, char_base.ground_friction * delta) # slow to stop
	else:
		char_base.velocity.x = lerp(char_base.velocity.x, 0, char_base.air_friction * delta)

	char_base.velocity = char_base.move_and_slide(char_base.velocity, Vector2.UP)


func _on_Hurtbox_hit_info(hit, kb_dir, kb_pow, d_percent, kb_scale):
	#char_base.got_hit = hit
	kb_direction = kb_dir
	kb_power = kb_pow
	if kb_scale == -1:
		kb_scaling = default_kb_scaling
	else:
		kb_scaling = kb_scale
	
	if char_base.percentage <= 50:
		hitstun_length = int(round(kb_power * 0.2))
	else:
		hitstun_length = int(round((kb_power * 0.4)/(100/char_base.percentage)))
	
	damage_percent = d_percent
	char_base.percentage += damage_percent
	print(char_base, " --> ", char_base.percentage, "%")
