class_name BoardV2 extends Node2D

const board_rows = 10
const board_cols = 9
enum Teams {Red = 1, Black = 2}
enum Kingdoms {MAGMA = 1, CLOUD = 2}

const palace_positions: Dictionary = {
	Vector2i(3,0): true,
	Vector2i(4,0): true,
	Vector2i(5,0): true,
	Vector2i(3,1): true,
	Vector2i(4,1): true,
	Vector2i(5,1): true,
	Vector2i(3,2): true,
	Vector2i(4,2): true,
	Vector2i(5,2): true,
	Vector2i(3,7): true,
	Vector2i(4,7): true,
	Vector2i(5,7): true,
	Vector2i(3,8): true,
	Vector2i(4,8): true,
	Vector2i(5,8): true,
	Vector2i(3,9): true,
	Vector2i(4,9): true,
	Vector2i(5,9): true
}
var scenes: Dictionary = {
	Kingdoms.MAGMA: {
		FigureComponent.Types.SOLDIER: load("res://Projects/Figure/V2/Magma/Soldier/Soldier.tscn"),
		FigureComponent.Types.GENERAL: load("res://Projects/Figure/V2/Magma/General/General.tscn"),
		FigureComponent.Types.ADVISOR: load("res://Projects/Figure/V2/Magma/Advisor/Advisor.tscn"),
		FigureComponent.Types.CHARIOT: load("res://Projects/Figure/V2/Magma/Chariot/Chariot.tscn"),
		FigureComponent.Types.HORSE: load("res://Projects/Figure/V2/Magma/Horse/Horse.tscn"),
		FigureComponent.Types.ELEPHANT: load("res://Projects/Figure/V2/Magma/Elephant/Elephant.tscn"),
		FigureComponent.Types.CANNON : load("res://Projects/Figure/V2/Magma/Cannon/Cannon.tscn"),
	},
	Kingdoms.CLOUD: {
		FigureComponent.Types.SOLDIER: load("res://Projects/Figure/V2/Cloud/Soldier/Soldier.tscn"),
		FigureComponent.Types.GENERAL: load("res://Projects/Figure/V2/Cloud/General/General.tscn"),
		FigureComponent.Types.ADVISOR: load("res://Projects/Figure/V2/Cloud/Advisor/Advisor.tscn"),
		FigureComponent.Types.CHARIOT: load("res://Projects/Figure/V2/Cloud/Chariot/Chariot.tscn"),
		FigureComponent.Types.HORSE: load("res://Projects/Figure/V2/Cloud/Horse/Horse.tscn"),
		FigureComponent.Types.ELEPHANT: load("res://Projects/Figure/V2/Cloud/Elephant/Elephant.tscn"),
		FigureComponent.Types.CANNON : load("res://Projects/Figure/V2/Cloud/Cannon/Cannon.tscn"),
	}
}


@export var ai: AI
@export var ui: GameplayUI

const fusion_chances: Dictionary = {
	FigureComponent.Types.SOLDIER: 0.4,
	FigureComponent.Types.CHARIOT: 0.15,
	FigureComponent.Types.CANNON: 0.25,
	FigureComponent.Types.HORSE: 0.3,
}

@export var spawn_AI_figure_chances: Dictionary = {
	FigureComponent.Types.CHARIOT: 0.25,
	FigureComponent.Types.CANNON: 0.3,
	FigureComponent.Types.HORSE: 0.45,
}
var markers : Dictionary
var turn: Teams = Teams.Red :
	set(t):
		turn = t
		clear_markers()
		activate_reds(turn == Teams.Red)
		activate_garrison(turn == Teams.Red)
		unfreeze_figures()

var state: Dictionary
# For which figure the markers are currently highlighted
var _selected_figure: FigureComponent

@export var ai_spawn_interval : int = 7

var move_number: int = 0:
	set(n):
		move_number = n
		if n == ai_spawn_interval:
			spawn_AI_figure()
			move_number = 0

func _ready() -> void:
	initialize_markers()
	
func initialize_markers():
	for i in range(board_rows):
		for j in range(board_cols):
			var marker: BoardMarker = $Markers.get_child(i).get_child(j)
			markers[Vector2i(j,i)] = marker
			markers[Vector2i(j,i)].board_position = Vector2i(j,i)
			marker.figure_move.connect(move_figure)
			marker.figure_spawn.connect(spawn_figure)

func initialize_position(init_state: Array[State]):
	for s in init_state:
		instantiate_figure(s.kingdom, s.type, s.position)
	
func instantiate_figure(kingdom: Kingdoms, type: FigureComponent.Types, pos: Vector2i) -> void:
	var figure: FigureComponent = scenes[kingdom][type].instantiate()
	figure.board = self
	figure.chess_component.position = pos
	figure.move_component.move_done.connect(figure_move_done)
	add_child(figure)

func show_move_markers(positions: Array[Vector2i], figure: FigureComponent) -> void:
	clear_markers()
	_selected_figure = figure
	for pos in positions:
		var marker: BoardMarker = markers[pos]
		marker.highlight(BoardMarker.Highlights.MOVE)

func set_figure(figure: FigureComponent, pos: Vector2i) -> void:
	state[pos] = figure
	figure.global_position = markers[pos].global_position

func move_figure(marker: BoardMarker) -> void:
	clear_markers()
	state.erase(_selected_figure.chess_component.position)
	if state.has(marker.board_position):
		capture(marker.board_position)
	state[marker.board_position] = _selected_figure
	_selected_figure.chess_component.change_position(marker.board_position)
	turn = Teams.Black
	update_energy_by_figure_type(_selected_figure.type)
	
func update_energy_by_figure_type(figure_type : FigureComponent.Types) -> void:
	if _selected_figure.type == FigureComponent.Types.GENERAL or _selected_figure.type == FigureComponent.Types.ADVISOR:
		ui.power_meter.discharge_energy()
	else:
		ui.power_meter.fill_energy()

func move_figure_AI(move: Dictionary) -> void:
	var figure: FigureComponent = state[move["start"]]
	state.erase(move["start"])
	if state.has(move["end"]):
		capture(move["end"])
	state[move["end"]] = figure
	figure.chess_component.change_position(move["end"])
	move_number += 1

func spawn_AI_figure():
	var pos : Vector2i
	while true:
		pos = Vector2i(randi_range(0, 8), randi_range(8, 9))
		if !palace_positions.has(pos) and !state.has(pos):
			break
	var chance: float = randf()
	if chance < spawn_AI_figure_chances[FigureComponent.Types.CHARIOT]:
		instantiate_figure(Kingdoms.CLOUD, FigureComponent.Types.CHARIOT, pos)
	elif chance < spawn_AI_figure_chances[FigureComponent.Types.CHARIOT] + spawn_AI_figure_chances[FigureComponent.Types.CANNON]:
		instantiate_figure(Kingdoms.CLOUD, FigureComponent.Types.CANNON, pos)
	else:
		instantiate_figure(Kingdoms.CLOUD, FigureComponent.Types.HORSE, pos)
		
func capture(pos: Vector2i) -> void:
	state[pos].delete()
	if get_generals().size() == 2:
		ui.power_meter.update_distance(get_figures(Teams.Red).size())

func clear_markers() -> void:
	for pos in markers:
		var m: BoardMarker = markers[pos]
		m.unhighlight()

func activate_reds(result: bool) -> void:
	for pos in state:
		var figure: FigureComponent = state[pos]
		if figure.chess_component.team == Teams.Red:
			figure.ui_component.active = result

func get_figures(team: Teams) -> Array[FigureComponent]:
	var figures: Array[FigureComponent] = []
	for pos in state:
		var figure: FigureComponent = state[pos]
		if figure.chess_component.team == team:
			figures.append(figure)
	return figures

func spawn_highlight(spawn_figure_type : FigureComponent.Types) -> void:
	clear_markers()
	for i in range(board_cols):
		for j in range(ui.power_meter.distance + 1):
			var pos: Vector2i = Vector2i(i,j)
			var marker: BoardMarker = markers[pos]
			if (state.has(pos) &&  
			!(state[pos].type == FigureComponent.Types.SOLDIER && spawn_figure_type == FigureComponent.Types.SOLDIER) && 
			 state[pos].chess_component.team == Teams.Red) || palace_positions.has(pos):
				continue
			marker.highlight(BoardMarker.Highlights.SPAWN)

func spawn_figure(marker: BoardMarker) -> void:
	clear_markers()
	ui.power_meter.substruct_energy()
	if state.has(marker.board_position):
		fusion(marker)
	else:
		instantiate_figure(Kingdoms.MAGMA, ui.garrison.selected_figure.type, marker.board_position)
	if state.has(marker.board_position):
		var figure = state[marker.board_position]
		figure.ui_component.active = false
	ui.power_meter.update_distance(get_figures(Teams.Red).size())

func activate_garrison(result: bool) -> void:
	ui.garrison.activate(result)


func fusion(marker: BoardMarker) -> void:
	var chance: float = randf()
	capture(marker.board_position)
	if chance < fusion_chances[FigureComponent.Types.CHARIOT]:
		instantiate_figure(Kingdoms.MAGMA, FigureComponent.Types.CHARIOT, marker.board_position)
	elif chance < fusion_chances[FigureComponent.Types.CHARIOT] + fusion_chances[FigureComponent.Types.CANNON]:
		instantiate_figure(Kingdoms.MAGMA, FigureComponent.Types.CANNON, marker.board_position)
	elif chance < fusion_chances[FigureComponent.Types.CHARIOT] + fusion_chances[FigureComponent.Types.CANNON] + fusion_chances[FigureComponent.Types.HORSE]:
		instantiate_figure(Kingdoms.MAGMA, FigureComponent.Types.HORSE, marker.board_position)
	else:
		state.erase(marker.board_position)

func figure_move_done() -> void:
	if check_game_over():
		return
	if _selected_figure != null:
		_selected_figure = null
		ai.make_move()
	else:
		turn = Teams.Red

func get_generals() -> Array[FigureComponent]:
	var generals: Array[FigureComponent] = []
	for pos in state:
		if state[pos].type == FigureComponent.Types.GENERAL:
			generals.append(state[pos])
	return generals

func check_game_over() -> bool:
	if get_generals().size() < 2:
		get_tree().change_scene_to_file("res://Projects/Levels/PrototypeMenu/prototype_menu.tscn")
		return true
	return false
		

func freeze(chance: float, team: Teams = Teams.Black) -> void:
	for pos in state:
		if !palace_positions.has(pos) and state[pos].chess_component.team == team:
			var ch: float = randf()
			if ch <= chance:
				state[pos].freeze()
	turn = team
	# without this blacks will do 2 moves in a row
	_selected_figure = null
	ai.make_move()

func unfreeze_figures() -> void:
	for pos in state:
		if state[pos].chess_component.team != turn:
			state[pos].unfreeze()
