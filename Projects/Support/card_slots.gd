class_name CardSlots extends Control

var ll_cards: Array[SpecialCard]
var hl_card: SpecialCard

@onready var ll_slots = $LLSlots
@onready var hl_slot = $HLSlot
var board: BoardV2
var cards: Dictionary = {}

enum SPECIALS {TreeTrunk, SnakeChain, WaterPortal, DisconnectionMistCard}

const card_names = {
	SPECIALS.TreeTrunk: "Tree Trunk",
	SPECIALS.SnakeChain: "Snake Chain",
	SPECIALS.WaterPortal: "Water Portal",
	SPECIALS.DisconnectionMistCard: "Disconnection Mist"
}

const specials_scenes = {
	SPECIALS.TreeTrunk: preload("res://Projects/Support/world1/tree_trunk.tscn"),
	SPECIALS.SnakeChain: preload("res://Projects/Support/world1/snake_chain.tscn"),
	SPECIALS.WaterPortal: preload("res://Projects/Support/world1/water_portal.tscn"),
	SPECIALS.DisconnectionMistCard: preload("res://Projects/Support/world1/disconnection_mist_card.tscn")
}


# specials assets
const tree_trunk = preload("res://Projects/Support/TmpWall.tscn")
const snake_chain = preload("res://Projects/Support/TmpFreeze.tscn")
const water_portal = preload("res://Projects/Support/TmpTrap.tscn")

# end special assets

static func get_card_scene(s: SPECIALS):
	return specials_scenes[s]

static var hl_points: Dictionary = {
	SPECIALS.DisconnectionMistCard: 3
}

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for special in GameState.state["lls"]:
		var card_scene = get_card_scene(special)
		var card: SpecialCard = card_scene.instantiate()
		ll_slots.add_child(card)
		card.on_click.connect(_on_card_click)
		cards[int(special)] = card
	if GameState.state["hl"] >= 0:
		var card: SpecialCard = specials_scenes[GameState.state["hl"]].instantiate()
		hl_slot.add_child(card)
		card.on_click.connect(_on_card_click)
		cards[int(GameState.state["hl"])] = card
	

func _on_card_click(s: SPECIALS):
	if cards[s].cooldown_counter != 0:
		return
	match s:
		SPECIALS.TreeTrunk:
			board.special_markers_highlight(s, true, false)
		SPECIALS.SnakeChain:
			board.special_markers_highlight(s, false, true)
		SPECIALS.WaterPortal:
			board.special_markers_highlight(s, true, false)
		SPECIALS.DisconnectionMistCard:
			use_special(s)

func use_special(s: SPECIALS, m: BoardMarker = null):
	match s:
		SPECIALS.TreeTrunk:
			board.spawn_wall([m], tree_trunk)
		SPECIALS.SnakeChain:
			board.freeze_piece([m],snake_chain)
		SPECIALS.WaterPortal:
			board.set_trap([m],water_portal)
		SPECIALS.DisconnectionMistCard:
			if !board.activate_disconnection_mist(BoardV2.Teams.Black):
				return
	cards[s].start_cooldown()
	board.clear_markers()

func activate(result: bool) -> void:
	visible = result

func countdown() -> void:
	for c in cards:
		cards[c].countdown()
