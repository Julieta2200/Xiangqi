class_name Tutorial extends Level

const green: Color = Color(0,1,0)

@onready var sections: Dictionary = {
	TutorialSections.PAWN: $CanvasLayer/SectionsContainer/Pawn,
	TutorialSections.HORSE: $CanvasLayer/SectionsContainer/Horse,
	TutorialSections.FREE: $CanvasLayer/SectionsContainer/Free,
	TutorialSections.ELEPHANT: $CanvasLayer/SectionsContainer/Elephant,
	TutorialSections.CANNON: $CanvasLayer/SectionsContainer/Cannon,
	TutorialSections.CHARIOT: $CanvasLayer/SectionsContainer/Chariot,
	TutorialSections.ADVISOR: $CanvasLayer/SectionsContainer/Advisor,
	TutorialSections.GENERAL: $CanvasLayer/SectionsContainer/General,
	TutorialSections.FLYINGGENERAL: $CanvasLayer/SectionsContainer/FlyingGeneral,
	TutorialSections.SPAWNING: $CanvasLayer/SectionsContainer/Spawning,
}

enum TutorialSections {
	FREE, PAWN, GENERAL, ADVISOR, ELEPHANT, HORSE, CHARIOT, CANNON, FLYINGGENERAL,
	SPAWNING
}
var current_section: TutorialSections = TutorialSections.FREE
var passed_text_shown: bool = false :
	set(v):
		if v:
			sections[current_section].modulate = green
			if !GameState.state["passed_tutorials"].has(current_section):
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
	_on_pawn_pressed()
	

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
		DialogSystem.DialogText.new("TUTORIAL_WELCOME", DialogSystem.CHARACTERS.Ashes),
	], true)
	current_section = TutorialSections.FREE
	gameplay_ui.hide()

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
					DialogSystem.DialogText.new("TUTORIAL_PAWN_CAPTURE_1", DialogSystem.CHARACTERS.Ashes),
				], true)
				passed_text_shown = true
		TutorialSections.HORSE:
			if (board.get_figures(BoardV2.Teams.Black).size() == 0):
				DialogSystem.start_dialog([
					DialogSystem.DialogText.new("TUTORIAL_PAWN_CAPTURE_2", DialogSystem.CHARACTERS.Ashes),
				], true)
				passed_text_shown = true
		TutorialSections.ELEPHANT:
			if (board.get_figures(BoardV2.Teams.Black).size() == 0):
				DialogSystem.start_dialog([
					DialogSystem.DialogText.new("TUTORIAL_PAWN_CAPTURE_3", DialogSystem.CHARACTERS.Ashes),
				], true)
				passed_text_shown = true
		TutorialSections.CANNON:
			if (board.get_figures(BoardV2.Teams.Black).size() == 1):
				DialogSystem.start_dialog([
					DialogSystem.DialogText.new("TUTORIAL_PAWN_CAPTURE_4", DialogSystem.CHARACTERS.Ashes),
				], true)
				passed_text_shown = true
		TutorialSections.CHARIOT:
			if (board.get_figures(BoardV2.Teams.Black).size() == 0):
				DialogSystem.start_dialog([
					DialogSystem.DialogText.new("TUTORIAL_PAWN_CAPTURE_5", DialogSystem.CHARACTERS.Ashes),
				], true)
				passed_text_shown = true
		TutorialSections.ADVISOR:
			if (board.get_figures(BoardV2.Teams.Black).size() == 0):
				DialogSystem.start_dialog([
					DialogSystem.DialogText.new("TUTORIAL_PAWN_CAPTURE_6", DialogSystem.CHARACTERS.Ashes),
				], true)
				passed_text_shown = true
		TutorialSections.GENERAL:
			if (board.get_figures(BoardV2.Teams.Black).size() == 0):
				DialogSystem.start_dialog([
					DialogSystem.DialogText.new("TUTORIAL_PAWN_CAPTURE_7", DialogSystem.CHARACTERS.Ashes),
				], true)
				passed_text_shown = true
		TutorialSections.FLYINGGENERAL:
			if (board.get_generals().size() == 1):
				DialogSystem.start_dialog([
					DialogSystem.DialogText.new("TUTORIAL_GENERAL_CAPTURE", DialogSystem.CHARACTERS.Ashes),
				], true)
				passed_text_shown = true
		TutorialSections.SPAWNING:
			if board.get_figures(BoardV2.Teams.Red).size() > 1:
				DialogSystem.start_dialog([
					DialogSystem.DialogText.new("TUTORIAL_SPAWN_SUCCESS", DialogSystem.CHARACTERS.Ashes),
				], true)
				passed_text_shown = true

func _on_pawn_pressed() -> void:
	gameplay_ui.power_meter.energy = 100
	var state: Array[State] = [
		State.new(BoardV2.Kingdoms.MAGMA, FigureComponent.Types.SOLDIER, Vector2i(4,3)),
		State.new(BoardV2.Kingdoms.FOG, FigureComponent.Types.SOLDIER, Vector2i(5,5)),
	]
	board.clear_board()
	board.initialize_position(state)
	DialogSystem.start_dialog([
		DialogSystem.DialogText.new("TUTORIAL_PAWN_DESCRIPTION_1", DialogSystem.CHARACTERS.Ashes),
		DialogSystem.DialogText.new("TUTORIAL_PAWN_DESCRIPTION_2", DialogSystem.CHARACTERS.Ashes),
	], true)
	current_section = TutorialSections.PAWN
	passed_text_shown = false
	gameplay_ui.hide()
		
func _on_horse_pressed() -> void:
	gameplay_ui.power_meter.energy = 100
	var state: Array[State] = [
		State.new(BoardV2.Kingdoms.MAGMA, FigureComponent.Types.HORSE, Vector2i(4,4)),
		State.new(BoardV2.Kingdoms.FOG, FigureComponent.Types.SOLDIER, Vector2i(5,4)),
	]
	board.clear_board()
	board.initialize_position(state)
	DialogSystem.start_dialog([
		DialogSystem.DialogText.new("TUTORIAL_HORSE_DESCRIPTION_1", DialogSystem.CHARACTERS.Ashes),
		DialogSystem.DialogText.new("TUTORIAL_HORSE_DESCRIPTION_2", DialogSystem.CHARACTERS.Ashes),
		DialogSystem.DialogText.new("TUTORIAL_HORSE_DESCRIPTION_3", DialogSystem.CHARACTERS.Ashes),
	], true)
	current_section = TutorialSections.HORSE
	passed_text_shown = false
	gameplay_ui.hide()

func _on_elephant_pressed() -> void:
	gameplay_ui.power_meter.energy = 100
	var state: Array[State] = [
		State.new(BoardV2.Kingdoms.MAGMA, FigureComponent.Types.ELEPHANT, Vector2i(2,0)),
		State.new(BoardV2.Kingdoms.FOG, FigureComponent.Types.SOLDIER, Vector2i(6,0)),
	]
	board.clear_board()
	board.initialize_position(state)
	DialogSystem.start_dialog([
		DialogSystem.DialogText.new("TUTORIAL_ELEPHANT_DESCRIPTION_1", DialogSystem.CHARACTERS.Ashes),
		DialogSystem.DialogText.new("TUTORIAL_ELEPHANT_DESCRIPTION_2", DialogSystem.CHARACTERS.Ashes),
		DialogSystem.DialogText.new("TUTORIAL_ELEPHANT_DESCRIPTION_3", DialogSystem.CHARACTERS.Ashes),
	], true)
	current_section = TutorialSections.ELEPHANT
	passed_text_shown = false
	gameplay_ui.hide()

func _on_cannon_pressed() -> void:
	gameplay_ui.power_meter.energy = 100
	var state: Array[State] = [
		State.new(BoardV2.Kingdoms.MAGMA, FigureComponent.Types.CANNON, Vector2i(7,2)),
		State.new(BoardV2.Kingdoms.FOG, FigureComponent.Types.SOLDIER, Vector2i(1,5)),
		State.new(BoardV2.Kingdoms.FOG, FigureComponent.Types.SOLDIER, Vector2i(1,7)),
	]
	board.clear_board()
	board.initialize_position(state)
	DialogSystem.start_dialog([
		DialogSystem.DialogText.new("TUTORIAL_CANNON_DESCRIPTION_1", DialogSystem.CHARACTERS.Ashes),
		DialogSystem.DialogText.new("TUTORIAL_CANNON_DESCRIPTION_2", DialogSystem.CHARACTERS.Ashes),
		DialogSystem.DialogText.new("TUTORIAL_CANNON_DESCRIPTION_3", DialogSystem.CHARACTERS.Ashes),
	], true)
	current_section = TutorialSections.CANNON
	passed_text_shown = false
	gameplay_ui.hide()

func _on_chariot_pressed() -> void:
	gameplay_ui.power_meter.energy = 100
	var state: Array[State] = [
		State.new(BoardV2.Kingdoms.MAGMA, FigureComponent.Types.CHARIOT, Vector2i(0,0)),
		State.new(BoardV2.Kingdoms.FOG, FigureComponent.Types.SOLDIER, Vector2i(4,4)),
	]
	board.clear_board()
	board.initialize_position(state)
	DialogSystem.start_dialog([
		DialogSystem.DialogText.new("TUTORIAL_CHARIOT_DESCRIPTION_1", DialogSystem.CHARACTERS.Ashes),
		DialogSystem.DialogText.new("TUTORIAL_CHARIOT_DESCRIPTION_2", DialogSystem.CHARACTERS.Ashes),
	], true)
	current_section = TutorialSections.CHARIOT
	passed_text_shown = false
	gameplay_ui.hide()

func _on_advisor_pressed() -> void:
	gameplay_ui.power_meter.energy = 100
	var state: Array[State] = [
		State.new(BoardV2.Kingdoms.MAGMA, FigureComponent.Types.ADVISOR, Vector2i(3,0)),
		State.new(BoardV2.Kingdoms.FOG, FigureComponent.Types.SOLDIER, Vector2i(5,2)),
	]
	board.clear_board()
	board.initialize_position(state)
	DialogSystem.start_dialog([
		DialogSystem.DialogText.new("TUTORIAL_ADVISOR_DESCRIPTION_1", DialogSystem.CHARACTERS.Ashes),
		DialogSystem.DialogText.new("TUTORIAL_ADVISOR_DESCRIPTION_2", DialogSystem.CHARACTERS.Ashes),
	], true)
	current_section = TutorialSections.ADVISOR
	passed_text_shown = false
	gameplay_ui.hide()

func _on_general_pressed() -> void:
	gameplay_ui.power_meter.energy = 100
	var state: Array[State] = [
		State.new(BoardV2.Kingdoms.MAGMA, FigureComponent.Types.GENERAL, Vector2i(4,0)),
		State.new(BoardV2.Kingdoms.FOG, FigureComponent.Types.SOLDIER, Vector2i(5,2)),
	]
	board.clear_board()
	board.initialize_position(state)
	DialogSystem.start_dialog([
		DialogSystem.DialogText.new("TUTORIAL_GENERAL_DESCRIPTION_1", DialogSystem.CHARACTERS.Ashes),
		DialogSystem.DialogText.new("TUTORIAL_GENERAL_DESCRIPTION_2", DialogSystem.CHARACTERS.Ashes),
		DialogSystem.DialogText.new("TUTORIAL_GENERAL_DESCRIPTION_3", DialogSystem.CHARACTERS.Ashes),
	], true)
	current_section = TutorialSections.GENERAL
	passed_text_shown = false
	gameplay_ui.hide()

func _on_flying_general_pressed() -> void:
	gameplay_ui.power_meter.energy = 100
	var state: Array[State] = [
		State.new(BoardV2.Kingdoms.MAGMA, FigureComponent.Types.GENERAL, Vector2i(4,0)),
		State.new(BoardV2.Kingdoms.MAGMA, FigureComponent.Types.ELEPHANT, Vector2i(4,3)),
		State.new(BoardV2.Kingdoms.FOG, FigureComponent.Types.GENERAL, Vector2i(4,9)),
	]
	board.clear_board()
	board.initialize_position(state)
	DialogSystem.start_dialog([
		DialogSystem.DialogText.new("TUTORIAL_FLYING_GENERAL_DESCRIPTION_1", DialogSystem.CHARACTERS.Ashes),
		DialogSystem.DialogText.new("TUTORIAL_FLYING_GENERAL_DESCRIPTION_2", DialogSystem.CHARACTERS.Ashes),
		DialogSystem.DialogText.new("TUTORIAL_FLYING_GENERAL_DESCRIPTION_3", DialogSystem.CHARACTERS.Ashes),
	], true)
	current_section = TutorialSections.FLYINGGENERAL
	passed_text_shown = false
	gameplay_ui.hide()

func _on_spawning_pressed() -> void:
	gameplay_ui.power_meter.energy = 100
	var state: Array[State] = [
		State.new(BoardV2.Kingdoms.MAGMA, FigureComponent.Types.GENERAL, Vector2i(4,0)),
		State.new(BoardV2.Kingdoms.FOG, FigureComponent.Types.GENERAL, Vector2i(5,9)),
	]
	board.clear_board()
	board.initialize_position(state)
	DialogSystem.start_dialog([
		DialogSystem.DialogText.new("TUTORIAL_SPAWNING_DESCRIPTION_1", DialogSystem.CHARACTERS.Ashes),
		DialogSystem.DialogText.new("TUTORIAL_SPAWNING_DESCRIPTION_2", DialogSystem.CHARACTERS.Ashes),
		DialogSystem.DialogText.new("TUTORIAL_SPAWNING_DESCRIPTION_3", DialogSystem.CHARACTERS.Ashes),
		DialogSystem.DialogText.new("TUTORIAL_SPAWNING_DESCRIPTION_4", DialogSystem.CHARACTERS.Ashes),
	], true)
	current_section = TutorialSections.SPAWNING
	passed_text_shown = false
	gameplay_ui.show()
	gameplay_ui.card_slots.activate(false)
