extends Node2D

@onready var lls: HBoxContainer = $CanvasLayer/LLs
@onready var equiped_lls: HBoxContainer = $CanvasLayer/EquipedLLs
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	fill_lls()


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

func _equip_ll(s: SpecialCard):
	s.reparent(equiped_lls)
	s.on_click_full.disconnect(_equip_ll)
	s.on_click_full.connect(_dequip_ll)

func _dequip_ll(s: SpecialCard):
	s.reparent(lls)
	s.on_click_full.disconnect(_dequip_ll)
	s.on_click_full.connect(_equip_ll)
