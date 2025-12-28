extends Level

const wave_1_chances: Dictionary = {
	FigureComponent.Types.SOLDIER: 0.55,
	FigureComponent.Types.HORSE: 0.45,
}

const wave_2_chances: Dictionary = {
	FigureComponent.Types.SOLDIER: 0.4,
	FigureComponent.Types.HORSE: 0.35,
	FigureComponent.Types.CANNON: 0.25,
}

const wave_3_chances: Dictionary = {
	FigureComponent.Types.SOLDIER: 0.35,
	FigureComponent.Types.HORSE: 0.3,
	FigureComponent.Types.CANNON: 0.2,
	FigureComponent.Types.CHARIOT: 0.15,
}

var wave_number: int = 1

@onready var mara: Node2D = %Mara
@onready var mara_animation: AnimationPlayer = %Mara/AnimationPlayer
@onready var mara_character: AnimatedSprite2D = %Mara/Character
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	super._ready()
	var state: Array[State] = [
		State.new(BoardV2.Kingdoms.MAGMA, FigureComponent.Types.GENERAL, Vector2i(4,0)),
		State.new(BoardV2.Kingdoms.MAGMA, FigureComponent.Types.ADVISOR, Vector2i(3,0)),
		State.new(BoardV2.Kingdoms.MAGMA, FigureComponent.Types.ADVISOR, Vector2i(5,0)),
	]
	board.initialize_position(state)
	_disable_play()
	DialogSystem.start_dialog([
		DialogSystem.DialogText.new("LEVEL_1_BOSS_ASHES_1", DialogSystem.CHARACTERS.Ashes),
		DialogSystem.DialogText.new("LEVEL_1_BOSS_MARA_1", DialogSystem.CHARACTERS.Mara),
		DialogSystem.DialogText.new("LEVEL_1_BOSS_ASHES_2", DialogSystem.CHARACTERS.Ashes),
	], true)
	DialogSystem.connect("dialog_finished", float_mara)

func float_mara() -> void:
	DialogSystem.disconnect("dialog_finished", float_mara)
	mara_animation.play("float")
	mara_character.play("floating")

func float_mara_end() -> void:
	start_wave_1()
	# DialogSystem.start_dialog([
	# 	DialogSystem.DialogText.new("LEVEL_1_BOSS_DIALOG_4", DialogSystem.CHARACTERS.Advisor),
	# ], true)
	# DialogSystem.connect("dialog_finished", start_wave_1)

func unfloat_mara() -> void:
	DialogSystem.disconnect("dialog_finished", unfloat_mara)
	mara_animation.play("unfloat")
	mara_character.play("default")

func unfloat_mara_end() -> void:
	dissolve_mara()
	# DialogSystem.start_dialog([
	# 	DialogSystem.DialogText.new("LEVEL_1_BOSS_DIALOG_6", DialogSystem.CHARACTERS.Advisor),
	# ], true)
	# DialogSystem.connect("dialog_finished", dissolve_mara)

func dissolve_mara() -> void:
	DialogSystem.disconnect("dialog_finished", dissolve_mara)
	mara_animation.play("dissolve")

func _on_game_over(win: BoardV2.GameOverResults, move_number: int):
	await get_tree().process_frame
	if win == BoardV2.GameOverResults.Win:
		gameplay_ui.objectives.complete_objectives(true)
		update_best_move_number(move_number)
		GameState.set_level_state(level_name, LevelMarker.LevelState.Captured)
		load_main_scene()
	else:
		gameplay_ui.objectives.complete_objectives(false)
		var lose_dialog_key: String = ""
		match wave_number:
			1:
				lose_dialog_key = "LEVEL_1_BOSS_WAVE_1_LOSE"
			2:
				lose_dialog_key = "LEVEL_1_BOSS_WAVE_2_LOSE"
			_:
				lose_dialog_key = "LEVEL_1_BOSS_WAVE_3_LOSE"
		
		DialogSystem.start_dialog([
			DialogSystem.DialogText.new(lose_dialog_key, DialogSystem.CHARACTERS.Mara),
		], true)
		DialogSystem.connect("dialog_finished", _lose_dialog_finished)

func _lose_dialog_finished() -> void:
	if DialogSystem.is_connected("dialog_finished", _lose_dialog_finished):
		DialogSystem.disconnect("dialog_finished", _lose_dialog_finished)
	show_game_over_ui()

func start_wave_1() -> void:
	DialogSystem.disconnect("dialog_finished", start_wave_1)
	_enable_play()
	var figures = generate_figures(wave_1_chances)
	instantiate_figures(figures)

func start_wave_2() -> void:
	DialogSystem.disconnect("dialog_finished", start_wave_2)
	_enable_play()
	var figures = generate_figures(wave_2_chances)
	instantiate_figures(figures)

func start_wave_3() -> void:
	DialogSystem.disconnect("dialog_finished", start_wave_3)
	_enable_play()
	var figures = generate_figures(wave_3_chances)
	instantiate_figures(figures)

func generate_figures(chances: Dictionary) -> Array:
	# Normalize probabilities to ensure they sum to 1.0
	var normalized_chances: Dictionary = {}
	var total_weight: float = 0.0
	for type in chances:
		total_weight += chances[type]
	
	# If total weight is 0 or very small, return empty array
	if total_weight <= 0.001:
		return []
	
	# Normalize
	for type in chances:
		normalized_chances[type] = chances[type] / total_weight
	
	# Create weighted list for fair selection
	var weighted_types: Array = []
	var cumulative_weights: Array = []
	var cumulative: float = 0.0
	
	for type in normalized_chances:
		cumulative += normalized_chances[type]
		weighted_types.append(type)
		cumulative_weights.append(cumulative)
	
	var figures: Array = []
	var available_columns: Array = range(9)
	available_columns.shuffle()  # Randomize column order for fair distribution
	
	# Filter out columns that are already occupied at spawn row (y=4)
	var valid_columns: Array = []
	for column in available_columns:
		var spawn_pos: Vector2i = Vector2i(column, 4)
		if not board.state.has(spawn_pos):
			valid_columns.append(column)
	
	if valid_columns.is_empty():
		return []  # No available positions
	
	# Calculate minimum figures to spawn (reduced for easier difficulty)
	var min_figures: int = min(4, valid_columns.size())
	var max_figures: int = min(6, valid_columns.size())
	var target_figures: int = randi_range(min_figures, max_figures)
	
	# Spawn figures with fair distribution
	for i in range(target_figures):
		if valid_columns.is_empty():
			break
		
		# Select a random column from available ones
		var column_idx = randi() % valid_columns.size()
		var column = valid_columns[column_idx]
		valid_columns.remove_at(column_idx)  # Remove to avoid duplicates
		
		# Select figure type using weighted random
		var r = randf()
		var selected_type = weighted_types[0]  # Default fallback
		for j in range(cumulative_weights.size()):
			if r <= cumulative_weights[j]:
				selected_type = weighted_types[j]
				break
		
		figures.append({ "type": selected_type, "column": column })
	
	return figures

func instantiate_figures(figures: Array) -> void:
	for figure in figures:
		var spawn_pos: Vector2i = Vector2i(figure["column"], 4)
		# Double-check that position is not occupied before spawning
		if not board.state.has(spawn_pos):
			board.instantiate_figure(BoardV2.Kingdoms.FOG, figure["type"], spawn_pos)

func check_game_over() -> bool:
	if mandatory_lose_conditions():
		_on_game_over(BoardV2.GameOverResults.Lose, board.move_number)
		return true
	if board.get_generals().size() < 1:
		_on_game_over(BoardV2.GameOverResults.Lose, board.move_number)
		return true
	if board.get_figures_by_type(FigureComponent.Types.ADVISOR).size() < 2:
		_on_game_over(BoardV2.GameOverResults.Lose, board.move_number)
		return true
	if board.get_figures(BoardV2.Teams.Black).size() == 0:
		match wave_number:
			1:
				board._selected_figure = null
				wave_number += 1
				_disable_play()
				DialogSystem.start_dialog([
					DialogSystem.DialogText.new("LEVEL_1_BOSS_WAVE_1_WIN", DialogSystem.CHARACTERS.Mara),
				], true)
				DialogSystem.connect("dialog_finished", start_wave_2)
			2:
				board._selected_figure = null
				wave_number += 1
				_disable_play()
				DialogSystem.start_dialog([
					DialogSystem.DialogText.new("LEVEL_1_BOSS_WAVE_2_WIN", DialogSystem.CHARACTERS.Mara),
				], true)
				DialogSystem.connect("dialog_finished", start_wave_3)
			_:
				_disable_play()
				DialogSystem.start_dialog([
					DialogSystem.DialogText.new("LEVEL_1_BOSS_WAVE_3_WIN_ASHES", DialogSystem.CHARACTERS.Ashes),
					DialogSystem.DialogText.new("LEVEL_1_BOSS_WAVE_3_WIN_MARA", DialogSystem.CHARACTERS.Mara),
					DialogSystem.DialogText.new("LEVEL_1_BOSS_WAVE_3_WIN_ASHES_2", DialogSystem.CHARACTERS.Ashes),
				], true)
				DialogSystem.connect("dialog_finished", unfloat_mara)
	return false
