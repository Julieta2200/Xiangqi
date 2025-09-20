class_name Tutorial extends Level


func _ready() -> void:
	super._ready()
	var state: Array[State] = [
		State.new(BoardV2.Kingdoms.MAGMA, FigureComponent.Types.GENERAL, Vector2i(4,0)),
		State.new(BoardV2.Kingdoms.MAGMA, FigureComponent.Types.ADVISOR, Vector2i(3,0)),
		State.new(BoardV2.Kingdoms.MAGMA, FigureComponent.Types.ADVISOR, Vector2i(5,0)),
		State.new(BoardV2.Kingdoms.MAGMA, FigureComponent.Types.ELEPHANT, Vector2i(2,0)),
		State.new(BoardV2.Kingdoms.MAGMA, FigureComponent.Types.ELEPHANT, Vector2i(6,0)),
		State.new(BoardV2.Kingdoms.MAGMA, FigureComponent.Types.HORSE, Vector2i(1,0)),
		State.new(BoardV2.Kingdoms.MAGMA, FigureComponent.Types.HORSE, Vector2i(7,0)),
		State.new(BoardV2.Kingdoms.MAGMA, FigureComponent.Types.CHARIOT, Vector2i(0,0)),
		State.new(BoardV2.Kingdoms.MAGMA, FigureComponent.Types.CHARIOT, Vector2i(8,0)),
		State.new(BoardV2.Kingdoms.MAGMA, FigureComponent.Types.CANNON, Vector2i(1,2)),
		State.new(BoardV2.Kingdoms.MAGMA, FigureComponent.Types.CANNON, Vector2i(7,2)),
		State.new(BoardV2.Kingdoms.MAGMA, FigureComponent.Types.SOLDIER, Vector2i(0,3)),
		State.new(BoardV2.Kingdoms.MAGMA, FigureComponent.Types.SOLDIER, Vector2i(2,3)),
		State.new(BoardV2.Kingdoms.MAGMA, FigureComponent.Types.SOLDIER, Vector2i(4,3)),
		State.new(BoardV2.Kingdoms.MAGMA, FigureComponent.Types.SOLDIER, Vector2i(6,3)),
		State.new(BoardV2.Kingdoms.MAGMA, FigureComponent.Types.SOLDIER, Vector2i(8,3)),

		State.new(BoardV2.Kingdoms.FOG, FigureComponent.Types.GENERAL, Vector2i(4,9)),
		State.new(BoardV2.Kingdoms.FOG, FigureComponent.Types.ADVISOR, Vector2i(3,9)),
		State.new(BoardV2.Kingdoms.FOG, FigureComponent.Types.ADVISOR, Vector2i(5,9)),
		State.new(BoardV2.Kingdoms.FOG, FigureComponent.Types.ELEPHANT, Vector2i(2,9)),
		State.new(BoardV2.Kingdoms.FOG, FigureComponent.Types.ELEPHANT, Vector2i(6,9)),
		State.new(BoardV2.Kingdoms.FOG, FigureComponent.Types.HORSE, Vector2i(1,9)),
		State.new(BoardV2.Kingdoms.FOG, FigureComponent.Types.HORSE, Vector2i(7,9)),
		State.new(BoardV2.Kingdoms.FOG, FigureComponent.Types.CHARIOT, Vector2i(0,9)),
		State.new(BoardV2.Kingdoms.FOG, FigureComponent.Types.CHARIOT, Vector2i(8,9)),
		State.new(BoardV2.Kingdoms.FOG, FigureComponent.Types.CANNON, Vector2i(1,7)),
		State.new(BoardV2.Kingdoms.FOG, FigureComponent.Types.CANNON, Vector2i(7,7)),
		State.new(BoardV2.Kingdoms.FOG, FigureComponent.Types.SOLDIER, Vector2i(0,6)),
		State.new(BoardV2.Kingdoms.FOG, FigureComponent.Types.SOLDIER, Vector2i(2,6)),
		State.new(BoardV2.Kingdoms.FOG, FigureComponent.Types.SOLDIER, Vector2i(4,6)),
		State.new(BoardV2.Kingdoms.FOG, FigureComponent.Types.SOLDIER, Vector2i(6,6)),
		State.new(BoardV2.Kingdoms.FOG, FigureComponent.Types.SOLDIER, Vector2i(8,6)),
	]
	board.initialize_position(state)

	DialogSystem.start_dialog([
		DialogSystem.DialogText.new("Welcome to the tutorial level! Here, you'll learn the basics of the game.", DialogSystem.CHARACTERS.Ashes),
	], true)