extends Node

export var starting_state: NodePath

var current_state: BaseState

func change_state(new_state: BaseState):
	if current_state:
		current_state.exit()
	
	current_state = new_state
	current_state.enter()

func init(char_base: CharacterBase):
	for child in get_children():
		child.char_base = char_base
	
	change_state(get_node(starting_state))

func physics_process(delta):
	#print(current_state)
	var new_state = current_state.physics_process(delta)
	if new_state:
		change_state(new_state)

func input(event: InputEvent):
	var new_state = current_state.input(event)
	if new_state:
		change_state(new_state)
