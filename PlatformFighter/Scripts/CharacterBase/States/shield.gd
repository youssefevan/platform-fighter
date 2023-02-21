extends BaseState

var enter_jump

func enter():
	.enter()
	char_base.shield_node.get_node("Collider").disabled = false
	
	if char_base.input_jump:
		enter_jump = true
	
	char_base.shield_node.visible = true
	char_base.shield_node.scale = Vector2(1, 1)

func physics_process(delta):
	
	char_base.velocity.x = lerp(char_base.velocity.x, 0, char_base.ground_friction * delta) # slow to stop
	
	char_base.velocity.y = 1 # keep in contact with ground
	char_base.velocity = char_base.move_and_slide(char_base.velocity, Vector2.UP)
	
	# State Changes
	if char_base.is_on_floor() == false:
		return char_base.idle
	
	if char_base.released_shield == true:
		return char_base.idle
	
	if char_base.input_jump == true or enter_jump == true:
		return char_base.jumpsquat

func exit():
	.exit()
	char_base.shield_node.visible = false
	char_base.shield_node.get_node("Collider").disabled = true
	char_base.got_hit = false

func _on_Shield_hit_shield(kb_pow, d_percent, hitbox_dir):
	#print("test2")
	var freeze_frames = int(d_percent / 3) + 1
	
	get_tree().paused = true
	yield(get_tree().create_timer((freeze_frames/60.0)), "timeout")
	get_tree().paused = false
	
	var hitbox_side = 0
	if hitbox_dir.x < 0:
		hitbox_side = -1
	else:
		hitbox_side = 1
	
	char_base.velocity.x = (d_percent + (kb_pow/5)) * hitbox_side
