extends MoveComponent

var animation : String
@onready var flying_attack_animation: AnimatedSprite2D = $"../flying_attack/flying_attack_anim"
@onready var attack_ball: Sprite2D = $"../flying_attack"

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

func generate_move_tween(target_pos):
	if get_tree() == null:
		return
	await get_tree().create_timer(0.5).timeout
	super.generate_move_tween(target_pos)

func move_to_position(marker: BoardMarker, initial_position: Vector2i = Vector2i.ZERO) -> void:
	var target_position: Vector2 = marker.global_position
	if !flying_animation(marker):
		move_animation(figure_component.chess_component.position, marker.board_position)
		generate_move_tween(target_position)
		
	play_sound(move_sound) 

func flying_animation(marker)-> bool:
	var flying_pos = figure_component.chess_component.flying_pos
	for i in flying_pos:
		if marker.board_position == i:
			if i.y == 7:
				flying_attack_animation.scale.y = 0.75
			elif i.y == 8:
				flying_attack_animation.scale.y = 0.87
			else:
				flying_attack_animation.scale.y = 1
			attack_ball.show()
			flying_attack_animation.play("flying_attack")
			return true
			
	return false
	
func _on_flying_attack_animation_finished() -> void:
	emit_signal("move_done")
