extends Node2D

@onready var board: BoardV2 = %Board

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var state: Array[State] = [
		State.new(BoardV2.Kingdoms.MAGMA, FigureComponent.Types.GENERAL, Vector2i(4,0)),
		State.new(BoardV2.Kingdoms.MAGMA, FigureComponent.Types.ADVISOR, Vector2i(3,0)),
		State.new(BoardV2.Kingdoms.MAGMA, FigureComponent.Types.ADVISOR, Vector2i(5,0)),
		State.new(BoardV2.Kingdoms.CLOUD, FigureComponent.Types.GENERAL, Vector2i(5,9)),
		State.new(BoardV2.Kingdoms.CLOUD, FigureComponent.Types.ADVISOR, Vector2i(4,8)),
		State.new(BoardV2.Kingdoms.CLOUD, FigureComponent.Types.ADVISOR, Vector2i(3,9)),
		State.new(BoardV2.Kingdoms.CLOUD, FigureComponent.Types.SOLDIER, Vector2i(0,6)),
		State.new(BoardV2.Kingdoms.CLOUD, FigureComponent.Types.SOLDIER, Vector2i(4,5)),
		State.new(BoardV2.Kingdoms.CLOUD, FigureComponent.Types.SOLDIER, Vector2i(2,6)),
		State.new(BoardV2.Kingdoms.CLOUD, FigureComponent.Types.HORSE, Vector2i(6,6)),
		State.new(BoardV2.Kingdoms.CLOUD, FigureComponent.Types.CANNON, Vector2i(7,7)),
		State.new(BoardV2.Kingdoms.CLOUD, FigureComponent.Types.CHARIOT, Vector2i(0,9)),
	]
	board.initialize_position(state)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
