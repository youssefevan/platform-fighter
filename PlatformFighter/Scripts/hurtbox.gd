extends Area2D

var got_hit
var kb_direction
var kb_power
var kb

signal hit_info(hit, knockback) # got_hit, kb_direction, kb_power, kb

func _on_Hurtbox_area_entered(area):
	if area.is_in_group("Hitbox"):
		var hitbox_direction = area.global_position.direction_to(self.global_position)
		
		kb_direction = area.get_kb_direction()
		
		if hitbox_direction.x < 0:
			kb_direction.x = -kb_direction.x
		else:
			kb_direction.x = kb_direction.x
		
		kb_power = area.kb_power
		kb = kb_direction * kb_power #* 50
		got_hit = true
		
		print("hit")
		
		emit_signal("hit_info", got_hit, kb)
