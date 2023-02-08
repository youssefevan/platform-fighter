class_name BaseState
extends Node

var char_base
export var animation_name: String

func connect_anims():
	if char_base.animations.is_connected("animation_finished", self, "anim_finished") != true:
		char_base.animations.connect("animation_finished", self, "anim_finished")
	
	if char_base.animations.is_connected("animation_started", self, "anim_started") != true:
		char_base.animations.connect("animation_started", self, "anim_started")

func enter():
	char_base.animations.play(animation_name)
	print("P", char_base.port, ": ", animation_name)

func input(event: InputEvent):
	return null

func physics_process(delta):
	return null

func exit():
	pass
