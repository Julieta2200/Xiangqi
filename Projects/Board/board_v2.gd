class_name BoardV2 extends Node2D

const board_rows = 10
const board_cols = 9
const spawn_distance: int = 3
enum Teams {Red = 1, Black = 2, Wall = 3}
enum Kingdoms {MAGMA = 1, CLOUD = 2, FOG = 3}
enum GameOverResults {None, Win, Lose}

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
signal move_done()

@export var tutorial: bool
@export var ai_can_spawn: bool = true

@export var ai: AIV2
@export var ui: GameplayUI
@export var camera : Camera

@export var spawn_AI_figure_chances: Dictionary = {
	FigureComponent.Types.CHARIOT: 0.3,
	FigureComponent.Types.CANNON: 0.4,
	FigureComponent.Types.HORSE: 0.3,
}

var level: Level
var markers : Dictionary
var turn: Teams = Teams.Red :
	set(t):
		if tutorial :
			turn = Teams.Red
		else:
			turn = t
		clear_markers()
		activate_reds(turn == Teams.Red)
		if ui.with_specials:
			activate_garrison(turn == Teams.Red)
			activate_cards(turn == Teams.Red)

var _AI_figure: FigureComponent
var state: Dictionary
# For which figure the markers are currently highlighted
var _selected_figure: FigureComponent
# For which special the markers are currently highlighted
var _selected_special: CardSlots.SPECIALS
var _walls: Array[FigureComponent]
var _freezes: Array
var _traps: Array

@export var ai_spawn_interval : int = 6
@onready var disconnection_mist_scene: PackedScene = preload("res://Projects/Support/world1/disconnection_mist.tscn")
var _mist: DisconnectionMist

var ai_move_number: int = 0:
	set(n):
		ai_move_number = n
		if n == ai_spawn_interval:
			if ai_can_spawn:
				spawn_AI_figure()
			ai_move_number = 0 

var move_number: int = 0:
	set(n):
		move_number = n
		ai_move_number += 1
		clear_wall()
		unfreeze_piece()
		ui.card_slots.countdown()

@export var strikes: int = 3 :
	set(s):
		strikes = s
		ui.strikes.apply_strike()
		if strikes == 0:
			var main_pieces: Array[FigureComponent] = get_figures(Teams.Red).filter(func(f): return f.type == FigureComponent.Types.GENERAL or f.type == FigureComponent.Types.ADVISOR)
			if main_pieces.size() > 0:
				for piece in main_pieces:
					piece.shader_component.apply_sickness_material()

@onready var strike_obj: Sprite2D = $Strike

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
			marker.spawn_done.connect(spawn_done)
			marker.special.connect(_on_use_special)
			marker.board = self

func initialize_position(init_state: Array[State]):
	for s in init_state:
		instantiate_figure(s.kingdom, s.type, s.position)

func clear_board() -> void:
	for pos in state:
		state[pos].delete()
	state.clear()
	clear_markers()
	clear_selected_figure()
	_selected_figure = null
	_walls.clear()
	_freezes.clear()
	_traps.clear()
	if _mist != null:
		_mist.queue_free()
		_mist = null
	turn = Teams.Red
	move_number = 0
	ai_move_number = 0

func instantiate_figure(kingdom: Kingdoms, type: FigureComponent.Types, pos: Vector2i) -> void:
	var figure: FigureComponent = scenes[kingdom][type].instantiate()
	figure.board = self
	figure.chess_component.position = pos
	figure.move_component.move_done.connect(figure_move_done)
	figure.move_component.attack_done.connect(figure_apply_move)
	add_child(figure)

func show_move_markers(positions: Array[Vector2i], figure: FigureComponent) -> void:
	clear_markers()
	if _selected_figure != null and _selected_figure != figure:
		clear_selected_figure()
	ui.garrison.deselect_cards()
	ui.card_slots.deselect_cards()
	_selected_figure = figure
	for pos in positions:
		# do not allow walk into the mist
		if _mist != null and _selected_figure.chess_component.team == _mist.target_team:
			match _mist.target_team:
				Teams.Red:
					if pos.y >= 5:
						continue
				Teams.Black:
					if pos.y <= 4:
						continue
		var marker: BoardMarker = markers[pos]
		
		if state.has(pos) and figure.chess_component.position != pos:
			marker.highlight(BoardMarker.Highlights.CAPTURE)
		else:
			marker.highlight(BoardMarker.Highlights.MOVE)
			
func hide_move_markers(positions: Array[Vector2i], figure: FigureComponent) -> void:
	for pos in positions:
		var marker: BoardMarker = markers[pos]
		marker.unhighlight()
	_selected_figure = null

func show_hover_markers(positions: Array[Vector2i], figure: FigureComponent) -> void:
	for pos in positions:
		var marker: BoardMarker = markers[pos]
		if marker.state == BoardMarker.Highlights.NONE:
			marker.highlight(BoardMarker.Highlights.HOVER)

func hide_hover_markers(positions: Array[Vector2i], figure: FigureComponent) -> void:
	for pos in positions:
		var marker: BoardMarker = markers[pos]
		if marker.state == BoardMarker.Highlights.HOVER:
			marker.unhighlight()

func set_figure(figure: FigureComponent, pos: Vector2i) -> void:
	state[pos] = figure
	figure.global_position = markers[pos].global_position

func move_figure(marker: BoardMarker) -> void:
	if _selected_figure.type == FigureComponent.Types.ELEPHANT:
		camera.shake()
	clear_markers()
	turn = Teams.Black
	update_energy_and_strikes(_selected_figure.type)
	
	if state.has(marker.board_position):
		capture(marker.board_position,_selected_figure.chess_component.position)
	else:
		figure_apply_move(_selected_figure.chess_component.position,marker.board_position)

func update_energy_and_strikes(figure_type : FigureComponent.Types) -> void:
	await get_tree().process_frame
	ui.power_meter.fill_energy()
	if (figure_type == FigureComponent.Types.GENERAL or figure_type == FigureComponent.Types.ADVISOR) \
	and move_number != 0:
		strikes -= 1
		strike_obj.show()

func move_figure_AI(move: Dictionary) -> void:
	var figure: FigureComponent = state[move["start"]]
	move_number += 1
	if state.has(move["end"]):
		capture(move["end"],move["start"])
	else:
		figure_apply_move(move["start"],move["end"])
	_AI_figure = figure

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
		
func capture(target_pos: Vector2i, attacker_pos: Vector2i) -> void:
	state[target_pos].move_component.disappear(attacker_pos)
	state[attacker_pos].move_component.attack(attacker_pos,target_pos)

func clear_markers(exceptions: Array[Vector2i] = []) -> void:
	for pos in markers:
		if pos in exceptions:
			continue
		var m: BoardMarker = markers[pos]
		m.unhighlight()
		
func clear_selected_figure():
	if _selected_figure != null:
		_selected_figure.ui_component.selected = false
		_selected_figure = null

func neutralize_markers() -> void:
	for pos in markers:
		var m: BoardMarker = markers[pos]
		m.state = m.Highlights.NONE

func activate_reds(result: bool) -> void:
	for pos in state:
		var figure: FigureComponent = state[pos]
		if figure.chess_component.team == Teams.Red and !figure.frozen:
			if (figure.type == FigureComponent.Types.GENERAL or figure.type == FigureComponent.Types.ADVISOR) \
			and strikes == 0:
				continue
			figure.ui_component.active = result

func get_figures(team: Teams) -> Array[FigureComponent]:
	var figures: Array[FigureComponent] = []
	for pos in state:
		var figure: FigureComponent = state[pos]
		if figure.chess_component.team == team:
			figures.append(figure)
	return figures

func get_figures_by_type(type: FigureComponent.Types) -> Array[FigureComponent]:
	var figures: Array[FigureComponent] = []
	for pos in state:
		var figure: FigureComponent = state[pos]
		if figure.type == type:
			figures.append(figure)
	return figures

func spawn_highlight(spawn_figure_type : FigureComponent.Types) -> void:
	ui.card_slots.deselect_cards()
	clear_markers()
	clear_selected_figure()
	const soldier_spawn_points = [Vector2i(0,3), Vector2i(2,3), Vector2i(4,3), Vector2i(6,3),Vector2i(8,3)]
	if spawn_figure_type == FigureComponent.Types.SOLDIER:
		for i in soldier_spawn_points:
			var marker: BoardMarker = markers[i]
			if !state.has(i):
				marker.highlight(BoardMarker.Highlights.SPAWN)
		return
	for i in range(board_cols):
		for j in range(spawn_distance):
			var pos: Vector2i = Vector2i(i,j)
			var marker: BoardMarker = markers[pos]
			if palace_positions.has(pos) or state.has(pos):
				continue
			marker.highlight(BoardMarker.Highlights.SPAWN)

func spawn_figure(marker: BoardMarker) -> void:
	neutralize_markers()
	clear_markers([marker.board_position])
	ui.power_meter.substruct_energy()
	instantiate_figure(Kingdoms.MAGMA, ui.garrison.selected_figure.type, marker.board_position)
	var figure = state[marker.board_position]
	figure.ui_component.active = false

func activate_garrison(result: bool) -> void:
	ui.garrison.activate(result)

func activate_cards(result: bool) -> void:
	ui.card_slots.activate(result)

func figure_move_done() -> void:
	await get_tree().process_frame
	if strikes > 0:
		strike_obj.hide()
	emit_signal("move_done")
	if tutorial:
		return
	if check_game_over() or ui.power_meter.energy == 0:
		return
	if _selected_figure != null:
		_selected_figure.ui_component.selected = false
		_selected_figure = null
		if tutorial:
			return
		ai.make_move()
	else:
		if _AI_figure != null:
			check_trap(_AI_figure)
		turn = Teams.Red
	if _mist != null and _mist.target_team != turn:
		_mist.deactivate(self)

func figure_apply_move(attacker_pos: Vector2i,target_pos: Vector2i):
	state[target_pos] = state[attacker_pos]
	state[attacker_pos].chess_component.change_position(target_pos)
	state.erase(attacker_pos)

func get_generals() -> Array[FigureComponent]:
	var generals: Array[FigureComponent] = []
	for pos in state:
		if state[pos].type == FigureComponent.Types.GENERAL:
			generals.append(state[pos])
	return generals

func check_game_over() -> bool:
	return level.check_game_over()

func is_victory(generals: Array) -> bool:
	return Teams.Red == generals[0].chess_component.team

func spawn_done(marker: BoardMarker) -> void:
	await get_tree().process_frame
	marker.unhighlight()


func special_markers_highlight(special: CardSlots.SPECIALS, is_free: bool = false, for_enemy: bool = false) -> void:
	clear_markers()
	clear_selected_figure()
	ui.garrison.deselect_cards()
	_selected_special = special
	for pos in markers:
		# specials are not affecting the palaces
		if palace_positions.has(pos):
			continue
			
		if is_free and (state.has(pos) or markers[pos].trap):
			continue
		
		if for_enemy and (!state.has(pos) or state[pos].chess_component.team != Teams.Black or state[pos].frozen):
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

func set_trap(markers: Array[BoardMarker] , trap_scene: PackedScene):
	for m in markers:
		var t = trap_scene.instantiate()
		t.board_position = m.board_position
		t.global_position = m.position
		m.trap = true
		add_child(t)
		_traps.append(t)

func check_trap(figure) -> void:
	for trap in _traps:
		if figure.chess_component.position == trap.board_position:
			figure.delete()
			markers[figure.chess_component.position].trap = false
			state.erase(figure.chess_component.position)
			trap.queue_free()
	
	_traps = _traps.filter(func(t): return figure.chess_component.position != t.board_position)

func activate_disconnection_mist(target_team: Teams) -> bool:
	if _mist != null:
		return false
	const positions: Dictionary = {
		Teams.Red: Vector2(1100,500),
		Teams.Black: Vector2(1100,1600)
	}
	
	_mist = disconnection_mist_scene.instantiate()
	_mist.position = positions[target_team]
	_mist.target_team = target_team
	add_child(_mist)
	_mist.activate(self)
	return true
