class_name BoardV2 extends Node2D

const board_rows = 10
const board_cols = 9
enum Teams {Red = 1, Black = 2, Wall = 3}
enum Kingdoms {MAGMA = 1, CLOUD = 2, FOG = 3}

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

const wall_positions: Dictionary = {
	Teams.Red: {
		Vector2i(2,0): true,
		Vector2i(6,0): true,
		Vector2i(2,1): true,
		Vector2i(6,1): true,
		Vector2i(2,2): true,
		Vector2i(6,2): true,
		Vector2i(3,3): true,
		Vector2i(4,3): true,
		Vector2i(5,3): true,
	},
	Teams.Black: {
		Vector2i(2,9): true,
		Vector2i(6,9): true,
		Vector2i(2,8): true,
		Vector2i(6,8): true,
		Vector2i(2,7): true,
		Vector2i(6,7): true,
		Vector2i(3,6): true,
		Vector2i(4,6): true,
		Vector2i(5,6): true,
	}
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
	},
	Kingdoms.FOG: {
		FigureComponent.Types.SOLDIER: load("res://Projects/Figure/V2/Fog/Soldier/Soldier.tscn"),
		FigureComponent.Types.GENERAL: load("res://Projects/Figure/V2/Fog/General/General.tscn"),
		FigureComponent.Types.ADVISOR: load("res://Projects/Figure/V2/Fog/Advisor/Advisor.tscn"),
		FigureComponent.Types.CHARIOT: load("res://Projects/Figure/V2/Fog/Chariot/Chariot.tscn"),
		FigureComponent.Types.HORSE: load("res://Projects/Figure/V2/Fog/Horse/Horse.tscn"),
		FigureComponent.Types.ELEPHANT: load("res://Projects/Figure/V2/Fog/Elephant/Elephant.tscn"),
		FigureComponent.Types.CANNON : load("res://Projects/Figure/V2/Fog/Cannon/Cannon.tscn"),
	},
}

signal game_over(win,move_number)
signal use_special(s: CardSlots.SPECIALS, m: BoardMarker)

@export var ai: AI
@export var ui: GameplayUI

@export var spawn_AI_figure_chances: Dictionary = {
	FigureComponent.Types.CHARIOT: 0.3,
	FigureComponent.Types.CANNON: 0.4,
	FigureComponent.Types.HORSE: 0.3,
}
var markers : Dictionary
var turn: Teams = Teams.Red :
	set(t):
		turn = t
		clear_markers()
		activate_reds(turn == Teams.Red)
		activate_garrison(turn == Teams.Red)
		activate_cards(turn == Teams.Red)


var state: Dictionary
# For which figure the markers are currently highlighted
var _selected_figure: FigureComponent
# For which special the markers are currently highlighted
var _selected_special: CardSlots.SPECIALS
var _walls: Array[FigureComponent]
var _freezes: Array


@export var ai_spawn_interval : int = 6

var ai_move_number: int = 0:
	set(n):
		ai_move_number = n
		if n == ai_spawn_interval:
			spawn_AI_figure()
			ai_move_number = 0 

var move_number: int = 0:
	set(n):
		move_number = n
		ai_move_number += 1
		clear_wall()
		unfreeze_piece()
		
func _ready() -> void:
	initialize_markers()
	
#func _process(delta: float) -> void:
	#if Input.is_action_just_released("instant_win"):
		#emit_signal("game_over", true, move_number)

func initialize_markers():
	for i in range(board_rows):
		for j in range(board_cols):
			var marker: BoardMarker = $Markers.get_child(i).get_child(j)
			markers[Vector2i(j,i)] = marker
			markers[Vector2i(j,i)].board_position = Vector2i(j,i)
			marker.figure_move.connect(move_figure)
			marker.figure_spawn.connect(spawn_figure)
			marker.spawn_done.connect(spawn_done)
			marker.special.connect(_on_use_special)

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
	markers[figure.chess_component.position].highlight(BoardMarker.Highlights.SELECTED)
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
		capture(marker.board_position,_selected_figure.chess_component.position)
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
		capture(move["end"],move["start"])
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
		instantiate_figure(Kingdoms.FOG, FigureComponent.Types.CHARIOT, pos)
	elif chance < spawn_AI_figure_chances[FigureComponent.Types.CHARIOT] + spawn_AI_figure_chances[FigureComponent.Types.CANNON]:
		instantiate_figure(Kingdoms.FOG, FigureComponent.Types.CANNON, pos)
	else:
		instantiate_figure(Kingdoms.FOG, FigureComponent.Types.HORSE, pos)
		
func capture(target_pos: Vector2i, attacker_pos = Vector2i(-1,-1)) -> void:
	state[target_pos].move_component.disappear(attacker_pos)
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
			if palace_positions.has(pos) or state.has(pos):
				continue
			marker.highlight(BoardMarker.Highlights.SPAWN)

func spawn_figure(marker: BoardMarker) -> void:
	ui.power_meter.substruct_energy()
	instantiate_figure(Kingdoms.MAGMA, ui.garrison.selected_figure.type, marker.board_position)
	var figure = state[marker.board_position]
	figure.ui_component.active = false
	figure.move_component.spawn_animation()
	ui.power_meter.update_distance(get_figures(Teams.Red).size())

func activate_garrison(result: bool) -> void:
	ui.garrison.activate(result)

func activate_cards(result: bool) -> void:
	ui.card_slots.activate(result)

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
	var generals = get_generals()
	if generals.size() < 2:
		var win = is_victory(generals)
		emit_signal("game_over", win, move_number)
		return true
	return false

func is_victory(generals: Array) -> bool:
	return Teams.Red == generals[0].chess_component.team

func spawn_done():
	await get_tree().process_frame
	clear_markers()


func special_markers_highlight(special: CardSlots.SPECIALS, is_free: bool = false, for_enemy: bool = false) -> void:
	_selected_special = special
	for pos in markers:
		# specials are not affecting the palaces
		if palace_positions.has(pos):
			continue
			
		if is_free and state.has(pos):
			continue
		
		if for_enemy and (!state.has(pos) or state[pos].chess_component.team != Teams.Black):
			continue
		
		markers[pos].highlight(BoardMarker.Highlights.SPECIAL)


func _on_use_special(m: BoardMarker):
	emit_signal("use_special", _selected_special, m)

func spawn_wall(markers: Array[BoardMarker], wall_scene: PackedScene) -> void:
	for m in markers:
		var w: FigureComponent = wall_scene.instantiate()
		w.board = self
		w.chess_component.position = m.board_position
		add_child(w)
		_walls.append(w)
	
func clear_wall() -> void:
	var i: int = 0
	for wall in _walls:
		wall.wall_component.move_count -= 1
		if wall.wall_component.move_count == 0:
			state.erase(wall.chess_component.position)
			# TODO: need to create delete method for wall
			wall.queue_free()
	
	_walls = _walls.filter(func(w): return w.wall_component.move_count > 0)

func freeze_piece(markers: Array[BoardMarker] , freeze_scene: PackedScene):
	for m in markers:
		var f = freeze_scene.instantiate()
		f.board_position = m.board_position
		f.global_position = m.position
		var figure = state[m.board_position]
		figure.frozen = true
		add_child(f)
		_freezes.append(f)

func unfreeze_piece() -> void:
	for freeze in _freezes:
		freeze.freeze_component.move_count -= 1
		if freeze.freeze_component.move_count == 0:
			state[freeze.board_position].frozen = false
			freeze.queue_free()
	
	_freezes = _freezes.filter(func(f): return f.freeze_component.move_count > 0)
