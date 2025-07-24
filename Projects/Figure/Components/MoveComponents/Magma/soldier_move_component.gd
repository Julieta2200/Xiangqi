extends MoveComponent


func move_animation(old_pos: Vector2, new_pos: Vector2) -> void:
	var direction = old_pos - new_pos
	
	if direction.y > 0:
		animated_sprite.play("move_back")
	elif direction.x > 0:
		animated_sprite.play("move_left")
	else:
		animated_sprite.play("move_right")

func attack(capture_figure_pos) -> void:
	var figure_pos = figure_component.chess_component.position
	self.capture_figure_pos = capture_figure_pos
	var direction = figure_pos - capture_figure_pos
	
	if direction.y < 0:
		animated_sprite.play("attack_back")
	elif direction.x > 0:
		animated_sprite.play("attack_left")
	else:
		animated_sprite.play("attack_right")
	
func _on_figure_animation_finished() -> void:
	if "attack" in animated_sprite.animation:
		emit_signal("attack_done",figure_component,capture_figure_pos)
	else:
		animated_sprite.play("idle")
