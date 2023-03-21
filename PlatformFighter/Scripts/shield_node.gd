extends Area2D

export var hitbox_node: NodePath
onready var hitbox = get_node(hitbox_node)

var shrink_rate = 0.08

var got_hit
var kb_power
var damage_percent
var kb_scaling
var hitbox_direction

signal hit_shield(kb_pow, d_percent, hitbox_dir)

func _on_Shield_area_entered(area):
	#print("test")
	if area.is_in_group("Hitbox"):
		if area != hitbox:
			hitbox_direction = area.global_position.direction_to(self.global_position)
			
			kb_power = area.kb_power
			damage_percent = area.damage
			kb_scaling = area.kb_scaling
			
			scale -= Vector2(area.damage/100, area.damage/100)
				
			emit_signal("hit_shield", kb_power, damage_percent, hitbox_direction)

func _ready():
	scale = Vector2(1,1)

func _physics_process(delta):
	#print(scale)
	if self.visible == true:
		scale -= Vector2(shrink_rate, shrink_rate) * delta
	elif scale < Vector2(1, 1):
		scale += Vector2(shrink_rate * 1.5, shrink_rate * 1.5) * delta
