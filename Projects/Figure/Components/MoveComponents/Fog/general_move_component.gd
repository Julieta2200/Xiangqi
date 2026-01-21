extends MoveComponent

var animation : String

func move_animation(old_pos: Vector2i, new_pos: Vector2i) -> void:
	var direction = old_pos - new_pos
	
	if direction.y < 0:
		animation = "move_back"
	elif direction.y > 0:
		animation = "move_front"
	elif direction.x > 0:
		animation = "move_left"
	else:
		animation = "move_right"
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
	animated_sprite.speed_scale = -1
	animated_sprite.frame = animated_sprite.sprite_frames.get_frame_count(animated_sprite.animation) - 1
	if shadow != null:
		shadow.play(animation)
	animated_sprite.play(animation)

func disappear(attacker_pos: Vector2i):
	figure_component.shader_component.dissolve()

func _on_shader_component_dissolve_finished() -> void:
	figure_component.delete()
