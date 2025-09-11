extends Node2D

@onready var lls: HBoxContainer = $CanvasLayer/LLs
@onready var hls: HBoxContainer = $CanvasLayer/HLs
@onready var equiped_lls: HBoxContainer = $CanvasLayer/EquipedLLs
@onready var equiped_hls: HBoxContainer = $CanvasLayer/EquipedHLs
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	fill_lls()
	fill_hls()


func fill_lls() -> void:
	for c in GameState.state.ll_cards:
		var card_scene = CardSlots.get_card_scene(c)
		var card: SpecialCard = card_scene.instantiate()
		if GameState.state.lls.has(c):
			equiped_lls.add_child(card)
			card.on_click_full.connect(_dequip_ll)
		else:
			lls.add_child(card)
			card.on_click_full.connect(_equip_ll)

func fill_hls() -> void:
	for c in GameState.state.hl_cards:
		var card_scene = CardSlots.get_card_scene(c)
		var card: SpecialCard = card_scene.instantiate()
		if GameState.state.hl == c:
			equiped_hls.add_child(card)
			card.on_click_full.connect(_dequip_hl)
		else:
			hls.add_child(card)
			card.on_click_full.connect(_equip_hl)

func _equip_ll(s: SpecialCard):
	s.reparent(equiped_lls)
	GameState.state.lls.append(s.special)
	s.on_click_full.disconnect(_equip_ll)
	s.on_click_full.connect(_dequip_ll)

func _dequip_ll(s: SpecialCard):
	s.reparent(lls)
	GameState.state.lls = GameState.state.lls.filter(func(ll): return ll != s.special)
	s.on_click_full.disconnect(_dequip_ll)
	s.on_click_full.connect(_equip_ll)

func _equip_hl(s: SpecialCard):
	s.reparent(equiped_hls)
	GameState.state.hl = s.special
	s.on_click_full.disconnect(_equip_hl)
	s.on_click_full.connect(_dequip_hl)

func _dequip_hl(s: SpecialCard):
	s.reparent(hls)
	GameState.state.hl = -1
	s.on_click_full.disconnect(_dequip_hl)
	s.on_click_full.connect(_equip_hl)

func _on_back_pressed() -> void:
	GameState.save_game()
	get_tree().change_scene_to_file("res://Projects/Levels/Overworld/overworld.tscn")
