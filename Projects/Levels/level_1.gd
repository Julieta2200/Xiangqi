extends Level

func _ready() -> void:
	super._ready()
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
