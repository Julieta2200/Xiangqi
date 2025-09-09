extends MoveComponent

var o_pos: Vector2i
var n_pos: Vector2i
var target_position: Vector2i

func move_to_position(marker: BoardMarker, initial_position: Vector2i = Vector2i.ZERO) -> void:
	target_position = marker.global_position
	
	move_animation(figure_component.chess_component.position, marker.board_position)

func move_animation(old_pos: Vector2i, new_pos: Vector2i) -> void:
	o_pos = old_pos
	n_pos = new_pos
	var direction = old_pos - new_pos
	print("dd",direction)
	if direction.y < 0 and direction.x > 0 and direction.y == -1:
		animated_sprite.play("move_back_semi_left")
	elif direction.y < 0 and direction.x > 0 and direction.y == -2:
		animated_sprite.play("move_back_lite_left")
	elif direction.y < 0 and direction.x < 0 and direction.y == -1:
		animated_sprite.play("move_back_semi_right")
	elif direction.y < 0 and direction.x < 0 and direction.y == -2:
		animated_sprite.play("move_back_lite_right")
	elif direction.y > 0 and direction.x > 0 and direction.y == 1:
		animated_sprite.play("move_front_semi_left")
	elif direction.y > 0 and direction.x > 0 and direction.y == 2:
		animated_sprite.play("move_front_lite_left")
	elif direction.y < 0 and direction.x < 0 and direction.y == -1:
		animated_sprite.play("move_front_semi_left")
	else:
		animated_sprite.play("move_front_lite_right")

#func generate_move_tween(target_pos):
	#await get_tree().create_timer(0.5).timeout
	#super.generate_move_tween(target_pos)
	
func _on_figure_animation_finished() -> void:
	var current_animation = animated_sprite.animation
	if current_animation.find("move") != -1:
		if animated_sprite.speed_scale == -1:
			animated_sprite.speed_scale = 1
			emit_signal("move_done")
		else:
			animated_sprite.speed_scale = -1
			animated_sprite.frame = animated_sprite.sprite_frames.get_frame_count(current_animation) - 1
			move_animation(o_pos, n_pos)
			figure_component.global_position = target_position
	else:
		animated_sprite.play("idle")
