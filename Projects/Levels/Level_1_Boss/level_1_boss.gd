extends Level

const wave_1_chances: Dictionary = {
	FigureComponent.Types.SOLDIER: 0.6,
	FigureComponent.Types.HORSE: 0.4,
}

const wave_2_chances: Dictionary = {
	FigureComponent.Types.SOLDIER: 0.6,
	FigureComponent.Types.HORSE: 0.3,
	FigureComponent.Types.CANNON: 0.1,
}

const wave_3_chances: Dictionary = {
	FigureComponent.Types.SOLDIER: 0.5,
	FigureComponent.Types.HORSE: 0.3,
	FigureComponent.Types.CANNON: 0.15,
	FigureComponent.Types.CHARIOT: 0.05,
}

var wave_number: int = 1
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	super._ready()
	var state: Array[State] = [
		State.new(BoardV2.Kingdoms.MAGMA, FigureComponent.Types.GENERAL, Vector2i(4,0)),
		State.new(BoardV2.Kingdoms.MAGMA, FigureComponent.Types.ADVISOR, Vector2i(3,0)),
		State.new(BoardV2.Kingdoms.MAGMA, FigureComponent.Types.ADVISOR, Vector2i(5,0)),
	]
	board.initialize_position(state)
	start_wave_1()

func start_wave_1() -> void:
	var figures = generate_figures(wave_1_chances)
	instantiate_figures(figures)

func start_wave_2() -> void:
	var figures = generate_figures(wave_2_chances)
	instantiate_figures(figures)

func start_wave_3() -> void:
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
	
	# Calculate minimum figures to spawn (reduced for easier difficulty)
	var min_figures: int = min(2, available_columns.size())
	var max_figures: int = min(4, available_columns.size())
	var target_figures: int = randi_range(min_figures, max_figures)
	
	# Spawn figures with fair distribution
	for i in range(target_figures):
		if available_columns.is_empty():
			break
		
		# Select a random column from available ones
		var column_idx = randi() % available_columns.size()
		var column = available_columns[column_idx]
		available_columns.remove_at(column_idx)  # Remove to avoid duplicates
		
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
		board.instantiate_figure(BoardV2.Kingdoms.FOG, figure["type"], Vector2i(figure["column"], 4))

func check_game_over() -> bool:
	if board.get_generals().size() < 1:
		_on_game_over(BoardV2.GameOverResults.Lose, board.move_number)
		return true
	if board.get_figures_by_type(FigureComponent.Types.ADVISOR).size() < 2:
		_on_game_over(BoardV2.GameOverResults.Lose, board.move_number)
		return true
	if board.get_figures(BoardV2.Teams.Black).size() == 0:
		match wave_number:
			1:
				start_wave_2()
			2:
				start_wave_3()
			_:
				_on_game_over(BoardV2.GameOverResults.Win, board.move_number)
				return true
	return false