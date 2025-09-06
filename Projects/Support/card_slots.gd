class_name CardSlots extends Control

var ll_cards: Array[SpecialCard]
var hl_card: SpecialCard

@onready var ll_slots = $LLSlots
var board: BoardV2

enum SPECIALS {TreeTrunk, SnakeChain, WaterPortal}

const specials_scenes = {
	SPECIALS.TreeTrunk: preload("res://Projects/Support/world1/tree_trunk.tscn"),
	SPECIALS.SnakeChain: preload("res://Projects/Support/world1/snake_chain.tscn"),
	SPECIALS.WaterPortal: preload("res://Projects/Support/world1/water_portal.tscn")
}


# specials assets
const tree_trunk = preload("res://Projects/Support/TmpWall.tscn")
const snake_chain = preload("res://Projects/Support/TmpFreeze.tscn")
const water_portal = preload("res://Projects/Support/TmpTrap.tscn")

# end special assets

static func get_card_scene(s: SPECIALS):
	return specials_scenes[s]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for special in SPECIALS.values():
		var card_scene = get_card_scene(special)
		var card: SpecialCard = card_scene.instantiate()
		ll_slots.add_child(card)
		card.on_click.connect(_on_card_click)

func _on_card_click(s: SPECIALS):
	match s:
		SPECIALS.TreeTrunk:
			board.special_markers_highlight(s, true, false)
		SPECIALS.SnakeChain:
			board.special_markers_highlight(s, false, true)
		SPECIALS.WaterPortal:
			board.special_markers_highlight(s, true, false)

func use_special(s: SPECIALS, m: BoardMarker = null):
	match s:
		SPECIALS.TreeTrunk:
			board.spawn_wall([m], tree_trunk)
		SPECIALS.SnakeChain:
			board.freeze_piece([m],snake_chain)
		SPECIALS.WaterPortal:
			board.set_trap([m],water_portal)
	
	board.clear_markers()

func activate(result: bool) -> void:
	visible = result
