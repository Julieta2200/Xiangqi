class_name MoveComponent extends Node

@export var speed: float
@export var figure_component: FigureComponent

@onready var animated_sprite: AnimatedSprite2D = $"../AnimatedSprite2D"
@export var shadow: AnimatedSprite2D
@export var move_audio: AudioStreamPlayer

signal move_done()

func move_to_position(marker: BoardMarker, initial_position: Vector2i = Vector2i.ZERO) -> void:
	var target_position: Vector2 = marker.global_position
	
	move_animation(figure_component.chess_component.position, marker.board_position)
	
	generate_move_tween(target_position)
	
func move_animation(old_pos: Vector2i, new_pos: Vector2i) -> void:
	pass

func _on_figure_animation_finished() -> void:
	var anim: String
	if figure_component.chess_component.team == BoardV2.Teams.Black:
		anim = "idle_down"
	else:
		anim = "idle"
	if shadow != null:
		shadow.play(anim)
	animated_sprite.play(anim)

func generate_move_tween(target_position):
	var tween = create_tween()
	tween.tween_property(figure_component, "global_position",
	 target_position, figure_component.global_position.distance_to(target_position)/speed)
	tween.finished.connect(func(): emit_signal("move_done"))

func disappear(attacker_pos: Vector2i):
	figure_component.delete()

func disappear_animation(target_pos: Vector2i, attacker_pos: Vector2i):
	pass

func play_move_audio():
	if move_audio != null:
		move_audio.play()
