class_name CardSlots extends Control

var ll_cards: Array[SpecialCard]
var hl_card: SpecialCard

@onready var ll_slots = $LLSlots
var board: BoardV2

enum SPECIALS {TreeTrunk}

const specials_scenes = {
	SPECIALS.TreeTrunk: preload("res://Projects/Support/world1/tree_trunk.tscn")
}


# specials assets
const tree_trunk = preload("res://Projects/Support/TmpWall.tscn")

# end special assets

static func get_card_scene(s: SPECIALS):
	return specials_scenes[s]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var card_scene = get_card_scene(SPECIALS.TreeTrunk)
	var card: SpecialCard = card_scene.instantiate()
	ll_slots.add_child(card)
	card.on_click.connect(_on_card_click)


func _on_card_click(s: SPECIALS):
	match s:
		SPECIALS.TreeTrunk:
			board.special_markers_highlight(s, true, false)
