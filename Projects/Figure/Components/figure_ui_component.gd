class_name FigureUIComponent extends Area2D

var active: bool = true : 
	set(a):
		active = a
		if !active or shader_component == null:
			return
		shader_component.remove_sickness_material()

var mouse_in: bool = false:
	set(m):
		mouse_in = m
		if !active :
			return
		if !selected:
			chess_component.show_moves()
		if shader_component == null:
			return
		if !selected or chess_component.team != BoardV2.Teams.Red:
			if mouse_in:
				show_horse_blocker()
			else:
				hide_horse_blocker()

var selected: bool:
	set(s):
		selected = s
		chess_component.show_moves()
		if shader_component == null:
			return
		if selected:
			shader_component.mouse_entered()
			show_horse_blocker()
		else:
			shader_component.mouse_exited()
			hide_horse_blocker()
			

@export var chess_component: ChessComponent
@export var shader_component: ShaderComponenet
@export var move_component: MoveComponent

func _ready() -> void:
	if shader_component == null:
		return
	shader_component.figure_ui_component = self

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

func show_horse_blocker():
	if chess_component.figure_component.type != FigureComponent.Types.HORSE:
		return
	for i in chess_component.blockers:
		i.shader_component.highlight_blocker()

func hide_horse_blocker():
	if chess_component.figure_component.type != FigureComponent.Types.HORSE:
		return
	for i in chess_component.blockers:
		i.shader_component.unhighlight_blocker(i.ui_component.active)
