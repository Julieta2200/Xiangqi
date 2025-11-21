extends MoveComponent

var old_pos: Vector2i
var new_pos: Vector2i
var target_position: Vector2i
@onready var shadow_pivot: Node2D = $"../ShadowPivot"

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
	animated_sprite.play(animation)
	shadow_pivot.modulate = Color(1,1,1,0)

func _on_figure_animation_finished() -> void:
	var current_animation = animated_sprite.animation
	if current_animation.find("move") != -1:
		if animated_sprite.speed_scale == -1:
			animated_sprite.speed_scale = 1
			animated_sprite.play("idle")
			shadow_pivot.modulate = Color(1,1,1,1)
			emit_signal("move_done")
		else:
			finish_move_animation()
	else:
		animated_sprite.play("idle")


func finish_move_animation():
	figure_component.global_position = target_position
	animated_sprite.speed_scale = -1
	animated_sprite.frame = animated_sprite.sprite_frames.get_frame_count(animated_sprite.animation) - 1
	move_animation(old_pos, new_pos)
