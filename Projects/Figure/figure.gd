class_name Figure extends Node2D

@export var team : int
@export var type : int


var board_position : Vector2:
	set(p):
		%Board.state[board_position.x][board_position.y] = null
		board_position = p
		self.global_position = %Board.markers[board_position.x][board_position.y].global_position
		%Board.state[board_position.x][board_position.y] = self


func available_moves():
	pass
