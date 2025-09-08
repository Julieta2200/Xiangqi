class_name FigureUIComponent extends Area2D

var active: bool = true

@export var chess_component: ChessComponent
@export var shader_component: ShaderComponenet

func _on_mouse_entered() -> void:
	if !active:
		return
	shader_component.mouse_entered()


func _on_mouse_exited() -> void:
	shader_component.mouse_exited()

func _on_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if !active:
		return
	if event is InputEventMouseButton:
		var mouse_event := event as InputEventMouseButton
		if mouse_event.button_index == MOUSE_BUTTON_LEFT and mouse_event.pressed:
			chess_component.show_moves()
