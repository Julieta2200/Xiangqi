class_name FigureComponent extends CharacterBody2D

enum Types {SOLDIER, GENERAL, ADVISOR, CHARIOT, HORSE, ELEPHANT, CANNON}

@export var board: BoardV2
@export var chess_component: ChessComponent
@export var ui_component: FigureUIComponent
@export var move_component: MoveComponent

@export var type: Types

func delete() -> void:
	queue_free()
