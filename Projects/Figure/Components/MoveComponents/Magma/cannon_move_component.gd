extends MoveComponent

var old_pos: Vector2i
var new_pos: Vector2i
var target_position: Vector2i

func move_to_position(marker: BoardMarker, initial_position: Vector2i = Vector2i.ZERO) -> void:
	target_position = marker.global_position
	
	move_animation(figure_component.chess_component.position, marker.board_position)

func move_animation(old_pos: Vector2i, new_pos: Vector2i) -> void:
	self.old_pos = old_pos
	self.new_pos = new_pos
	var animation: String = "move"
	var direction = old_pos - new_pos
	
	if direction.y < 0:
		animation += "_back"
	elif direction.y > 0:
		animation += "_front"
	elif direction.x > 0:
		animation += "_left"
	elif direction.x < 0:
		animation += "_right"
	if shadow != null:
		shadow.play(animation)
	animated_sprite.play(animation)

func _on_figure_animation_finished() -> void:
	var current_animation = animated_sprite.animation
	if current_animation.find("move") != -1:
		if animated_sprite.speed_scale == -1:
			animated_sprite.speed_scale = 1
			super._on_figure_animation_finished()
			emit_signal("move_done")
		else:
			finish_move_animation()
	else:
		super._on_figure_animation_finished()

func finish_move_animation():
	figure_component.global_position = target_position
	animated_sprite.speed_scale = -1
	animated_sprite.frame = animated_sprite.sprite_frames.get_frame_count(animated_sprite.animation) - 1
	move_animation(old_pos, new_pos)
