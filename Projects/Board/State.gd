class_name State

var kingdom: BoardV2.Kingdoms
var type: FigureComponent.Types
var position: Vector2i

func _init(kingdom: BoardV2.Kingdoms, type: FigureComponent.Types, position: Vector2i) -> void:
	self.kingdom = kingdom
	self.type = type
	self.position = position
