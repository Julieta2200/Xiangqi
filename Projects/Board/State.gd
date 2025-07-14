class_name State

var team: BoardV2.Kingdoms
var type: FigureComponent.Types
var position: Vector2i

func _init(team: BoardV2.Kingdoms, type: FigureComponent.Types, position: Vector2i) -> void:
	self.team = team
	self.type = type
	self.position = position
