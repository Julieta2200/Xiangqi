class_name FigureComponent extends CharacterBody2D

enum Types {SOLDIER, GENERAL, ADVISOR, CHARIOT, HORSE, ELEPHANT, CANNON}

@export var board: BoardV2
@export var chess_component: ChessComponent
@export var ui_component: FigureUIComponent
@export var move_component: MoveComponent

@export var type: Types

var frozen: bool = false
@onready var tmp_freeze_scene = load("res://Projects/Support/tmp_freeze.tscn")
var freeze_obj: Node2D

func delete() -> void:
	queue_free()

func freeze() -> void:
	if frozen:
		return
	frozen = true
	freeze_obj = tmp_freeze_scene.instantiate()
	add_child(freeze_obj)

func unfreeze() -> void:
	if !frozen:
		return
	frozen = false
	freeze_obj.queue_free()
