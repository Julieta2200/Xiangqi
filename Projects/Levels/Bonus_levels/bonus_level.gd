extends Level


func _ready() -> void:
	super._ready()
	var state: Array[State] = [
		State.new(BoardV2.Kingdoms.MAGMA, FigureComponent.Types.GENERAL, Vector2i(3,0)),
		State.new(BoardV2.Kingdoms.MAGMA, FigureComponent.Types.ADVISOR, Vector2i(4,1)),
		State.new(BoardV2.Kingdoms.MAGMA, FigureComponent.Types.ADVISOR, Vector2i(5,0)),
		State.new(BoardV2.Kingdoms.FOG, FigureComponent.Types.GENERAL, Vector2i(4,9)),
		State.new(BoardV2.Kingdoms.FOG, FigureComponent.Types.ADVISOR, Vector2i(3,9)),
		State.new(BoardV2.Kingdoms.FOG, FigureComponent.Types.ADVISOR, Vector2i(5,9)),
		State.new(BoardV2.Kingdoms.MAGMA, FigureComponent.Types.SOLDIER, Vector2i(4,7)),
		State.new(BoardV2.Kingdoms.MAGMA, FigureComponent.Types.SOLDIER, Vector2i(3,7)),
		State.new(BoardV2.Kingdoms.MAGMA, FigureComponent.Types.SOLDIER, Vector2i(5,7)),
	]
	board.initialize_position(state)
