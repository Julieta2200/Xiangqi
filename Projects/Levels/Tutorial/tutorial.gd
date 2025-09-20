class_name Tutorial extends Level

const black: Color = Color(0,0,0)
const blue: Color = Color(0,0,1)
const green: Color = Color(0,1,0)

@onready var sections: Dictionary = {
	TutorialSections.PAWN: $CanvasLayer/SectionsContainer/Pawn,
}

enum TutorialSections {
	FREE, PAWN, GENERAL, ADVISOR, ELEPHANT, HORSE, CHARIOT, CANNON
}
var current_section: TutorialSections = TutorialSections.FREE
var passed_text_shown: bool = false

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
	board.move_done.connect(check_state)

	DialogSystem.start_dialog([
		DialogSystem.DialogText.new("Welcome to the Playground! You can play around here, or choose a topic which you want to learn!", DialogSystem.CHARACTERS.Ashes),
	], false, 3.0)


func _on_pawn_pressed() -> void:
	var state: Array[State] = [
		State.new(BoardV2.Kingdoms.MAGMA, FigureComponent.Types.SOLDIER, Vector2i(4,3)),
	]
	board.clear_board()
	board.initialize_position(state)
	DialogSystem.start_dialog([
		DialogSystem.DialogText.new("This is a Pawn. Pawns can only move forward one step at a time, but once they cross the river, they can also move sideways.", DialogSystem.CHARACTERS.Ashes),
		DialogSystem.DialogText.new("Try moving the Pawn to the other side of the river!", DialogSystem.CHARACTERS.Ashes),
	], true)
	current_section = TutorialSections.PAWN
	passed_text_shown = false

func check_state() -> void:
	if passed_text_shown:
		return
	match current_section:
		TutorialSections.FREE:
			return
		TutorialSections.PAWN:
			var pawn: FigureComponent = board.get_figures(BoardV2.Teams.Red)[0]
			if pawn.chess_component.position.y >= 5:
				DialogSystem.start_dialog([
					DialogSystem.DialogText.new("Great! Now try moving it sideways.", DialogSystem.CHARACTERS.Ashes),
				], false, 3.0)
				passed_text_shown = true