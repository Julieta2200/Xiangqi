extends MoveComponent

var animation: String


func move_animation(old_pos: Vector2i, new_pos: Vector2i) -> void:
	var animation: String = "move_"
	if new_pos.y < old_pos.y:
		animation += "up_"
	else:
		animation += "down_"

	if new_pos.x < old_pos.x:
		animation += "left"
	else:
		animation += "right"
	if shadow != null:
		shadow.play(animation)
	animated_sprite.play(animation)
