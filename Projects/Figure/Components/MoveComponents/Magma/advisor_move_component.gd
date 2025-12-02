extends MoveComponent

@export var path_signs: Node2D
@export var path_animation: AnimationPlayer
@export var edge_sign: AnimatedSprite2D
@export var center_sign: AnimatedSprite2D
@export var main_sprite: AnimatedSprite2D
@export var attack_sprite: AnimatedSprite2D


const move_up_left = "move_up_left"

var marker: BoardMarker
var initial_position: Vector2i
var appear: bool
var animation: String
var sign: AnimatedSprite2D
var attacker_pos: Vector2i
var target_pos: Vector2i
var frame: int = 0

func move_to_position(marker: BoardMarker, initial_position: Vector2i = Vector2i.ZERO) -> void:
	self.marker = marker
	self.initial_position = initial_position
	var animation: String = "move_"
	if marker.board_position.y > initial_position.y:
		animation += "up_"
	else:
		animation += "down_"

	if marker.board_position.x < initial_position.x:
		animation += "left"
	else:
		animation += "right"
	self.animation = animation
	if shadow != null:
		shadow.play(animation)
	main_sprite.play(animation)
	main_sprite.frame = frame


func _on_main_sprite_animation_finished() -> void:
	var current_animation = animated_sprite.animation
	if disappear_animation_finished():
		return
	elif current_animation.find("attack") != -1:
		frame = 4
	elif !appear:
		setup_signs(initial_position, marker.board_position)
	else:
		main_sprite_idle_animation()

func setup_final_signs() -> void:
	await get_tree().process_frame
	figure_component.global_position = marker.global_position
	var sign_end_position = marker.board_position
	var is_edge = update_sign_flip(sign_end_position)
	get_sign_with_direction(is_edge)
	sign.show()
	sign.play("appear")
	await get_tree().create_timer(0.3).timeout
	appear_animation()

func setup_signs(start: Vector2i, end: Vector2i) -> void:
	var edge :bool = update_sign_flip(start)
	var signs: Array[Node] = path_signs.get_children()
	var rot_x: int = 1
	var rot_y: int = 1
	
	if !edge:
		var offset := 15.5
		if start.x < end.x:
			path_signs.position.x += offset
		elif start.x > end.x:
			path_signs.position.x -= offset
	else:
		path_signs.position.x = 0
	
	if signs[0].position.x > 0:
		if start.x > end.x:
			rot_x = -1
	else:
		if start.x < end.x:
			rot_x = -1
	
	if signs[0].position.y > 0:
		if start.y < end.y:
			rot_y = -1
	else:
		if start.y > end.y:
			rot_y = -1
			
	rotate_path(rot_x, rot_y)
	await get_tree().process_frame
	show_signs(edge)

func show_signs(edge: bool) -> void:
	if shadow != null:
		shadow.hide()
	main_sprite.hide()
	get_sign_with_direction(edge)
	sign.show()
	sign.play("appear")
	path_animation.play("appear", -1, 4)

func rotate_path(x: int, y: int):
	var signs: Array[Node] = path_signs.get_children()
	for sign in signs:
		sign.position.x *= x
		sign.position.y *= y

func hide_sign() -> void:
	sign.hide()

func appear_animation() -> void:
	appear = true
	if shadow != null:
		shadow.show()
	main_sprite.show()
	main_sprite.play_backwards(animation)

func main_sprite_idle_animation():
	frame = 0
	if shadow != null:
		shadow.play("idle_up")
	main_sprite.play("idle_up")
	appear = false
	emit_signal("move_done")

func _on_sign_animation_finished() -> void:
	call_deferred("hide_sign")

func update_sign_flip(sign_pos: Vector2i) -> bool:
	match sign_pos.x:
		3, 5:
			edge_sign.flip_h = sign_pos.x == 3
			edge_sign.flip_v = sign_pos.y == 2
			return true
	return false
	
func get_sign_with_direction(is_edge : bool):
	if is_edge:
		sign = edge_sign
	else:
		sign = center_sign
	
#Disappear animation
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

func disappear_animation_finished() -> bool:
	var current_animation = animated_sprite.animation
	if current_animation.find("disappear") != -1:
		figure_component.delete()
	return current_animation.find("disappear") != -1 

func disappear(attacker_pos: Vector2i):
	disappear_animation(figure_component.chess_component.position,attacker_pos)

func attack(attacker_pos: Vector2i,target_pos: Vector2i):
	self.attacker_pos = attacker_pos
	self.target_pos = target_pos
	attack_sprite.modulate.a = 1
	attack_sprite.global_position = figure_component.board.state[target_pos].global_position
	attack_sprite.play("attack")
	
	animation = "attack_"
	if attacker_pos.y > target_pos.y:
		animation += "down_"
	else:
		animation += "up_"

	if attacker_pos.x < target_pos.x:
		animation += "right"
	else:
		animation += "left"
	
	if shadow != null:
		shadow.play(animation)
	main_sprite.play(animation)


func _on_attack_animation_finished() -> void:
	emit_signal("attack_done",attacker_pos,target_pos)
	attack_sprite.modulate.a = 0
