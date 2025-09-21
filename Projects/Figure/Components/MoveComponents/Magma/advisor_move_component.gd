extends MoveComponent

@export var path_signs: Node2D
@export var path_animation: AnimationPlayer
@export var edge_sign: AnimatedSprite2D
@export var center_sign: AnimatedSprite2D
@export var main_sprite: AnimatedSprite2D

const disappear_up_left = "disappear_up_left"

var marker: BoardMarker
var initial_position: Vector2i
var appear: bool
var animation: String
var sign: AnimatedSprite2D


func move_to_position(marker: BoardMarker, initial_position: Vector2i = Vector2i.ZERO) -> void:
	self.marker = marker
	self.initial_position = initial_position
	var animation: String = "disappear_"
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


func _on_main_sprite_animation_finished() -> void:
	if !appear:
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
	
