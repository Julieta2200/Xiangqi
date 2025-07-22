extends MoveComponent

@export var path_signs: Node2D
@export var path_animation: AnimationPlayer
@export var edge_sign: AnimatedSprite2D
@export var center_sign: Sprite2D
@export var main_sprite: AnimatedSprite2D

const disappear_up_left = "disappear_up_left"

var marker: BoardMarker
var initial_position: Vector2i
var appear: bool
var animation: String

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
	main_sprite.play(animation)


func _on_main_sprite_animation_finished() -> void:
	if !appear:
		setup_signs(initial_position, marker.board_position)
	else:
		setup_final_signs()

func setup_final_signs() -> void:
	await get_tree().process_frame
	center_sign.show()
	await get_tree().create_timer(0.5).timeout
	center_sign.hide()
	main_sprite.play("idle_up")
	appear = false
	emit_signal("move_done")

func setup_signs(start: Vector2i, end: Vector2i) -> void:
	var edge: bool
	match start.x:
		3, 5:
			edge_sign.flip_h = start.x == 3
			edge_sign.flip_v = start.y == 2
			edge = true
	
	var signs: Array[Node] = path_signs.get_children()
	var rot_x: int = 1
	var rot_y: int = 1
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
	main_sprite.hide()
	if edge:
		edge_sign.show()
		edge_sign.play("appear")
	else:
		center_sign.show()
		
	path_animation.play("appear", -1, 1.3)


func rotate_path(x: int, y: int):
	var signs: Array[Node] = path_signs.get_children()
	for sign in signs:
		sign.position.x *= x
		sign.position.y *= y

func hide_edge_sign() -> void:
	edge_sign.hide()

func _on_edge_sign_animation_finished() -> void:
	call_deferred("hide_edge_sign")


func appear_animation() -> void:
	appear = true
	figure_component.global_position = marker.global_position
	main_sprite.show()
	main_sprite.play_backwards(animation)
