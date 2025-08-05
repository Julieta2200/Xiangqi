class_name MoveComponent extends Node

@export var speed: float
@export var figure_component: FigureComponent

@onready var animated_sprite: AnimatedSprite2D = $"../AnimatedSprite2D"
signal move_done()

func move_to_position(marker: BoardMarker, initial_position: Vector2i = Vector2i.ZERO) -> void:
	var target_position: Vector2 = marker.global_position
	
	move_animation(figure_component.chess_component.position, marker.board_position)
	
	generate_move_tween(target_position)
	
func move_animation(old_pos: Vector2i, new_pos: Vector2i) -> void:
	pass

func _on_figure_animation_finished() -> void:
	animated_sprite.play("idle")

func generate_move_tween(target_position):
	var tween = create_tween()
	tween.tween_property(figure_component, "global_position",
	 target_position, figure_component.global_position.distance_to(target_position)/speed)
	tween.finished.connect(func(): emit_signal("move_done"))
