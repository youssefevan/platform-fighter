extends BaseState

var hitbox_direction
var kb_angle
var new_kb_angle
var kb_power
var damage_percent
var kb_scaling
var default_kb_scaling = 3
var kb_direction
var kb_angle_modifier

var frame = 0

var hitstun_length

func enter():
	.enter()
	var freeze_frames = int(damage_percent / 3) + 2
	
	#print((freeze_frames/60.0))
	get_tree().paused = true
	yield(get_tree().create_timer((freeze_frames/60.0)), "timeout")
	get_tree().paused = false
	
	calculate_di()
	char_base.got_hit = false

func calculate_di():
	var max_angle_difference = 18 # degrees
	
	var directional_input = null
	if Vector2(char_base.right - char_base.left, char_base.up - char_base.down) != Vector2.ZERO:
		directional_input = int(rad2deg(Vector2(char_base.right - char_base.left, char_base.up - char_base.down).angle()))
	else:
		directional_input = null
	
	var processed_di = 0
	if directional_input != null:
		if (directional_input > (-kb_angle + 90)) or (directional_input < (-kb_angle - 90)):
			if directional_input < 0:
				processed_di = -directional_input - 90
			else:
				processed_di = -directional_input + 270
		
			kb_angle_modifier = ((-kb_angle - processed_di)/90) * max_angle_difference
			new_kb_angle = -kb_angle - kb_angle_modifier
			
			kb_direction = get_kb_direction(-new_kb_angle)
		
		else:
			processed_di = directional_input
			
			kb_angle_modifier = ((-kb_angle - processed_di)/90) * max_angle_difference
			new_kb_angle = -kb_angle - kb_angle_modifier
			
			kb_direction = get_kb_direction(-new_kb_angle)
	else:
		kb_direction = get_kb_direction(kb_angle)
	
	var kb_base = (char_base.percentage * kb_scaling) + kb_power + damage_percent # kb_scaling has the greatest affect at high percents
	var knockback = kb_base / char_base.weight
	
	print("---Hit---")
	print("P", char_base.port, " --> ", char_base.percentage, "%")
	print("Knockback: ", knockback)
	print("Hitstun: ", hitstun_length)
	print("DI: ", directional_input)
	print("Processed DI: ", processed_di)
	print("KB Angle Modifier: ", kb_angle_modifier)
	print("KB Base Angle: ", -kb_angle)
	print("KB Angle w/ DI: ", new_kb_angle)
	print("---------")
	
	char_base.velocity = kb_direction * knockback

func get_kb_direction(angle):
	var kb_angle_radians = deg2rad(angle)
	var kb_x = cos(kb_angle_radians)
	var kb_y = sin(kb_angle_radians)
	var output = Vector2(kb_x, kb_y)
	
	if hitbox_direction.x < 0:
		output.x *= -1
	else:
		output.x *= 1
	
	return output


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
		char_base.velocity.x = lerp(char_base.velocity.x, 0, char_base.air_friction * delta)
		
		if char_base.velocity.y > char_base.fall_speed:
			char_base.velocity.y = char_base.fall_speed
		
	else:
		if frame > 1:
			pass#return char_base.idle
		elif frame <= 1:
			if kb_direction.y >= 0.8:
				char_base.velocity.y = -char_base.velocity.y
		
		char_base.velocity.x = lerp(char_base.velocity.x, 0, char_base.ground_friction * delta) # slow to stop
		

	char_base.velocity = char_base.move_and_slide(char_base.velocity, Vector2.UP)

func _on_Hurtbox_hit_info(hit, kb_ang, kb_pow, d_percent, kb_scale, hitbox_dir):
	#char_base.got_hit = hit
	hitbox_direction = hitbox_dir
	kb_angle = kb_ang
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

func exit():
	.exit()
	frame = 0
