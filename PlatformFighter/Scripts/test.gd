extends KinematicBody2D

var got_hit = false
var kb

var grav = 200

var velocity = Vector2.ZERO

func _physics_process(delta):
	#print(velocity)
	if got_hit == true:
		print("hit")
		velocity += kb
		got_hit = false
	
	if !is_on_floor():
		velocity.y += grav * delta
	else:
		pass
	
	velocity.x = lerp(velocity.x, 0, 3 * delta)
	
	velocity = move_and_slide(velocity, Vector2.UP)


func _on_Hurtbox_hit_info(hit, knockback):
	got_hit = hit
	kb = knockback
