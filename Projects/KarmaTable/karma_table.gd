extends Node2D

@onready var lls: HBoxContainer = $CanvasLayer/LLs
@onready var hls: HBoxContainer = $CanvasLayer/HLs
@onready var equiped_lls: HBoxContainer = $CanvasLayer/EquipedLLs
@onready var equiped_hls: HBoxContainer = $CanvasLayer/EquipedHLs

@onready var hint_bubbles: Array[HintBubble] = [
	$CanvasLayer/Hints/HintBubble,
	$CanvasLayer/Hints/HintBubble2,
	$CanvasLayer/Hints/HintBubble3,
]
@onready var play_button: Button = $CanvasLayer/Play
@onready var back_button: Button = $CanvasLayer/Back

var _hint_index: int = 0


var level_1_dialog: Array[DialogSystem.DialogText] = [
	DialogSystem.DialogText.new("Some test text", DialogSystem.CHARACTERS.Jakat),
]

var dialogs: Dictionary = {
	"1": level_1_dialog,
}


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	fill_lls()
	fill_hls()
	if GameState.state["first_karma_table_run"]:
		run_hint_system()
		return

	run_dialog()


func run_dialog() -> void:
	if dialogs.has(GameState.current_level_info["name"]):
		var dialog: Array[DialogSystem.DialogText] = dialogs[GameState.current_level_info["name"]]
		if dialog.size() > 0:
			DialogSystem.start_dialog(dialog, true)

func fill_lls() -> void:
	for c in GameState.state.ll_cards:
		var card_scene = CardSlots.get_card_scene(c)
		var card: SpecialCard = card_scene.instantiate()
		if GameState.state.lls.has(c):
			card.description.hide()
			equiped_lls.add_child(card)
			card.on_click_full.connect(_dequip_ll)
		else:
			card.description.show()
			lls.add_child(card)
			card.on_click_full.connect(_equip_ll)

func fill_hls() -> void:
	for c in GameState.state.hl_cards:
		var card_scene = CardSlots.get_card_scene(c)
		var card: SpecialCard = card_scene.instantiate()
		if GameState.state.hl == c:
			card.description.hide()
			equiped_hls.add_child(card)
			card.on_click_full.connect(_dequip_hl)
		else:
			card.description.show()
			hls.add_child(card)
			card.on_click_full.connect(_equip_hl)

func _equip_ll(s: SpecialCard):
	s.description.hide()
	s.reparent(equiped_lls)
	GameState.state.lls.append(s.special)
	s.on_click_full.disconnect(_equip_ll)
	s.on_click_full.connect(_dequip_ll)

func _dequip_ll(s: SpecialCard):
	s.description.show()
	s.reparent(lls)
	GameState.state.lls = GameState.state.lls.filter(func(ll): return ll != s.special)
	s.on_click_full.disconnect(_dequip_ll)
	s.on_click_full.connect(_equip_ll)

func _equip_hl(s: SpecialCard):
	s.description.hide()
	s.reparent(equiped_hls)
	GameState.state.hl = s.special
	s.on_click_full.disconnect(_equip_hl)
	s.on_click_full.connect(_dequip_hl)

func _dequip_hl(s: SpecialCard):
	s.description.show()
	s.reparent(hls)
	GameState.state.hl = -1
	s.on_click_full.disconnect(_dequip_hl)
	s.on_click_full.connect(_equip_hl)

func _on_back_pressed() -> void:
	GameState.save_game()
	get_tree().change_scene_to_file("res://Projects/Levels/Overworld/overworld.tscn")

func _on_play_pressed() -> void:
	if GameState.current_level_info["scene"]:
		GameState.save_game()
		get_tree().change_scene_to_packed(GameState.current_level_info["scene"])

func run_hint_system() -> void:
	play_button.hide()
	back_button.hide()
	if _hint_index >= hint_bubbles.size():
		GameState.state["first_karma_table_run"] = false
		GameState.save_game()
		play_button.show()
		back_button.show()
		run_dialog()
		return
	hint_bubbles[_hint_index].show()
	_hint_index += 1
	