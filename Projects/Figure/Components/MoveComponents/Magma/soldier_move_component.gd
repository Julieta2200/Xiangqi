extends MoveComponent

var animation : String
var attacker_pos: Vector2i
var target_pos: Vector2i

func move_animation(old_pos: Vector2i, new_pos: Vector2i) -> void:
	var direction = old_pos - new_pos
	
	if direction.y < 0:
		animation = "move_back"
	elif direction.x > 0:
		animation = "move_left"
	else:
		animation = "move_right"
	if shadow != null:
		shadow.play(animation)
	animated_sprite.play(animation)

func disappear_animation(target_pos: Vector2i, attacker_pos: Vector2i):
	var direction = target_pos - attacker_pos
	
	if direction.y < 0:
		animation = "disappear_back"
	elif direction.y > 0:
		animation = "disappear_front"
	elif direction.x > 0:
		animation = "disappear_left"
	else:
		animation = "disappear_right"
	if shadow != null:
		shadow.play(animation)
	animated_sprite.play(animation)

func _on_figure_animation_finished() -> void:
	var current_animation = animated_sprite.animation
	if current_animation.find("disappear") != -1:
		figure_component.delete()
	elif current_animation.find("attack") != -1:
		emit_signal("attack_done",attacker_pos,target_pos)
	else:
		super._on_figure_animation_finished()

func disappear(attacker_pos: Vector2i):
	disappear_animation(figure_component.chess_component.position,attacker_pos)

func attack(attacker_pos: Vector2i,target_pos: Vector2i):
	self.attacker_pos = attacker_pos
	self.target_pos = target_pos
	var direction = attacker_pos - target_pos
	
	if direction.y < 0:
		animation = "attack_back"
	elif direction.x > 0:
		animation = "attack_left"
	else:
		animation = "attack_right"
	if shadow != null:
		shadow.play(animation)
	animated_sprite.play(animation)
