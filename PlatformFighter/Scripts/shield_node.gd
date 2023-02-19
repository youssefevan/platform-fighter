extends Area2D

export var hitbox_node: NodePath
onready var hitbox = get_node(hitbox_node)

var got_hit
var kb_power
var damage_percent
var kb_scaling
var hitbox_direction

signal hit_shield(kb_pow, d_percent, kb_scale, hitbox_dir)

func _on_Hurtbox_area_entered(area):
	print("test")
	if area.is_in_group("Hitbox"):
		if area != hitbox:
			hitbox_direction = area.global_position.direction_to(self.global_position)
			
			kb_power = area.kb_power
			damage_percent = area.damage
			kb_scaling = area.kb_scaling
				
			emit_signal("hit_shield", kb_power, damage_percent, kb_scaling, hitbox_direction)
