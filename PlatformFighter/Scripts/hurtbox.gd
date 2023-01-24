extends Area2D

export var hitbox_node: NodePath
onready var hitbox = get_node(hitbox_node)

var got_hit
var kb_direction
var kb_power
var damage_percent

signal hit_info(hit, kb_dir, kb_pow, d_percent) # got_hit, kb_direction, kb_power, kb

func _on_Hurtbox_area_entered(area):
	if area.is_in_group("Hitbox"):
		#print(area)
		#print(hitbox)
		#print(area == hitbox)
		if (area != hitbox):
			var hitbox_direction = area.global_position.direction_to(self.global_position)
			
			kb_direction = area.get_kb_direction()
			
			if hitbox_direction.x < 0:
				kb_direction.x = -kb_direction.x
			else:
				kb_direction.x = kb_direction.x
			
			kb_power = area.kb_power
			damage_percent = area.damage
			got_hit = true
			
			emit_signal("hit_info", got_hit, kb_direction, kb_power, damage_percent)
