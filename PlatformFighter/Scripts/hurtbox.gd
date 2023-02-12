extends Area2D

export var hitbox_node: NodePath
onready var hitbox = get_node(hitbox_node)

var got_hit
var kb_angle
var kb_power
var damage_percent
var kb_scaling
var hitbox_direction

signal hit_info(hit, kb_ang, kb_pow, d_percent, kb_scale, hitbox_dir) # got_hit, kb_direction, kb_power, damage_percent, kb_scaling

func _on_Hurtbox_area_entered(area):
	if area.is_in_group("Hitbox"):
		#print(area)
		#print(hitbox)
		#print(area == hitbox)
		if (area != hitbox):
			hitbox_direction = area.global_position.direction_to(self.global_position)
			
			kb_angle = area.kb_angle
			kb_power = area.kb_power
			damage_percent = area.damage
			kb_scaling = area.kb_scaling
			got_hit = true
			
			emit_signal("hit_info", got_hit, kb_angle, kb_power, damage_percent, kb_scaling, hitbox_direction)
