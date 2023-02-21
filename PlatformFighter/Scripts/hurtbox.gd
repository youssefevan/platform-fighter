extends Area2D

export var hitbox_node: NodePath
onready var hitbox = get_node(hitbox_node)

export var shield_node: NodePath
onready var shield = get_node(shield_node)

var got_hit
var kb_angle
var kb_power
var damage_percent
var hitbox_direction
var kb_scaling

signal hit_info(hit, kb_ang, kb_pow, d_percent, kb_scale, hitbox_dir)

func _on_Hurtbox_area_entered(area):
	if area.is_in_group("Hitbox"):
		if area != hitbox:
			if shield.get_node("Collider").disabled == true:
				hitbox_direction = area.global_position.direction_to(self.global_position)
				
				kb_angle = area.kb_angle
				kb_power = area.kb_power
				kb_scaling = area.kb_scaling
				damage_percent = area.damage
				got_hit = true
				
				emit_signal("hit_info", got_hit, kb_angle, kb_power, damage_percent, kb_scaling, hitbox_direction)
