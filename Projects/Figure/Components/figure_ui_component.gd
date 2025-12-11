class_name FigureUIComponent extends Area2D

var active: bool = true : 
	set(a):
		active = a
		if shader_component == null:
			return
		if active:
			shader_component.remove_sickness_material()
		if active and mouse_in:
			shader_component.mouse_entered()
		else:
			shader_component.mouse_exited()

var mouse_in: bool = false:
	set(m):
		mouse_in = m
		chess_component.show_moves()

var selected: bool :
	set(s):
		selected = s
		if shader_component == null:
			return
		if selected:
			shader_component.mouse_entered()
		else:
			shader_component.mouse_exited()
			

@export var chess_component: ChessComponent
@export var shader_component: ShaderComponenet
@export var move_component: MoveComponent

func _on_mouse_entered() -> void:
	mouse_in = true
	if !active:
		return
	shader_component.mouse_entered()


func _on_mouse_exited() -> void:
	mouse_in = false
	if !selected:
		shader_component.mouse_exited()

func _on_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton:
		var mouse_event := event as InputEventMouseButton
		if mouse_event.button_index == MOUSE_BUTTON_LEFT and mouse_event.pressed:
			if !active:
				move_component.shake()
			else:
				selected = !selected
				chess_component.show_moves()
