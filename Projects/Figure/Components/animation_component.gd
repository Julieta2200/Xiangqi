class_name AnimationComponent extends Node

@export var animation_player: AnimationPlayer
@export var animated_sprite: AnimatedSprite2D

const walk_up: String = "walk_up"
const walk_down: String = "walk_down"
const walk_left: String = "walk_left"
const walk_right: String = "walk_right"

func play(animation: String) -> void:
	pass
