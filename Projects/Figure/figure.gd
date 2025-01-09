class_name Figure extends Node

var board_position : Vector2:
	set(p):
		board_position = p
		self.position = %Board.markers[board_position.x][board_position.y]


func available_moves():
	pass
