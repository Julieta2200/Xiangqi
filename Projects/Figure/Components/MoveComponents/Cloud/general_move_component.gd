extends MoveComponent

var target_position: Vector2i
func move_animation(old_pos: Vector2i, new_pos: Vector2i) -> void:
	animated_sprite.play("move_1")

func generate_move_tween(target_pos):
	target_position = target_pos
	
func _on_figure_animation_finished() -> void:
	if animated_sprite.animation == "move_1":
		figure_component.global_position = target_position
		animated_sprite.play("move_2")
	else:
		animated_sprite.play("idle")
