class_name Tutorial extends Level

const green: Color = Color(0,1,0)

@onready var sections: Dictionary = {
	TutorialSections.PAWN: $CanvasLayer/SectionsContainer/Pawn,
	TutorialSections.HORSE: $CanvasLayer/SectionsContainer/Horse,
	TutorialSections.FREE: $CanvasLayer/SectionsContainer/Free,
}

enum TutorialSections {
	FREE, PAWN, GENERAL, ADVISOR, ELEPHANT, HORSE, CHARIOT, CANNON
}
var current_section: TutorialSections = TutorialSections.FREE
var passed_text_shown: bool = false :
	set(v):
		if v:
			sections[current_section].modulate = green
			GameState.state["passed_tutorials"].append(current_section)
			GameState.save_game()
		passed_text_shown = v

func _ready() -> void:
	super._ready()
	if !GameState.state.has("passed_tutorials"):
		GameState.state["passed_tutorials"] = []
		GameState.save_game()
	for s in GameState.state["passed_tutorials"]:
		if sections.has(int(s)):
			sections[int(s)].modulate = green
	board.move_done.connect(check_state)
	_on_free_pressed()
	

func _on_free_pressed() -> void:
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
	board.clear_board()
	board.initialize_position(state)

	DialogSystem.start_dialog([
		DialogSystem.DialogText.new("Welcome to the Playground! You can play around here, or choose a topic which you want to learn!", DialogSystem.CHARACTERS.Ashes),
	], false, 3.0)
	current_section = TutorialSections.FREE

func _on_pawn_pressed() -> void:
	var state: Array[State] = [
		State.new(BoardV2.Kingdoms.MAGMA, FigureComponent.Types.SOLDIER, Vector2i(4,3)),
		State.new(BoardV2.Kingdoms.FOG, FigureComponent.Types.SOLDIER, Vector2i(5,5)),
	]
	board.clear_board()
	board.initialize_position(state)
	DialogSystem.start_dialog([
		DialogSystem.DialogText.new("This is a Pawn. Pawns can only move forward one step at a time, but once they cross the river, they can also move sideways.", DialogSystem.CHARACTERS.Ashes),
		DialogSystem.DialogText.new("Try moving the Pawn to the other side of the river and capture enemy Pawn!", DialogSystem.CHARACTERS.Ashes),
	], true)
	current_section = TutorialSections.PAWN
	passed_text_shown = false

func check_state() -> void:
	await get_tree().process_frame
	if passed_text_shown:
		return
	match current_section:
		TutorialSections.FREE:
			return
		TutorialSections.PAWN:
			if (board.get_figures(BoardV2.Teams.Black).size() == 0):
				DialogSystem.start_dialog([
					DialogSystem.DialogText.new("Great! You have captured the enemy Pawn.", DialogSystem.CHARACTERS.Ashes),
				], false, 3.0)
				passed_text_shown = true
		TutorialSections.HORSE:
			if (board.get_figures(BoardV2.Teams.Black).size() == 0):
				DialogSystem.start_dialog([
					DialogSystem.DialogText.new("Well done! You have captured the enemy Pawn.", DialogSystem.CHARACTERS.Ashes),
				], false, 5.0)
				passed_text_shown = true

		
func _on_horse_pressed() -> void:
	var state: Array[State] = [
		State.new(BoardV2.Kingdoms.MAGMA, FigureComponent.Types.HORSE, Vector2i(4,4)),
		State.new(BoardV2.Kingdoms.FOG, FigureComponent.Types.SOLDIER, Vector2i(5,4)),
	]
	board.clear_board()
	board.initialize_position(state)
	DialogSystem.start_dialog([
		DialogSystem.DialogText.new("This is a Horse. Horses move in an L-shape: two steps in one direction and then one step perpendicular.", DialogSystem.CHARACTERS.Ashes),
		DialogSystem.DialogText.new("However, if there is a piece directly next to the Horse in the direction it is moving, it cannot jump over it.", DialogSystem.CHARACTERS.Ashes),
		DialogSystem.DialogText.new("Try moving the Horse around, and capture the enemy Pawn!", DialogSystem.CHARACTERS.Ashes),
	], true)
	current_section = TutorialSections.HORSE
	passed_text_shown = false
