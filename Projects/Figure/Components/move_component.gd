class_name MoveComponent extends Node

@export var speed: float
@export var figure_component: FigureComponent

func move_to_position(target_position: Vector2) -> void:
	var tween = create_tween()
	tween.tween_property(figure_component, "global_position",
	 target_position, figure_component.global_position.distance_to(target_position)/speed)
