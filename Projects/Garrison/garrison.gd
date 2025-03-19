extends Control

@onready var figure_cards: Array = $FigureCards.get_children()

var selected_figure: FigureCard
var check_selected_figure : bool 

 
@export var figures: Dictionary = {
	Figure.Types.Soldier: 0,
	Figure.Types.Chariot: 0,
	Figure.Types.Cannon: 0,
	Figure.Types.Elephant: 0,
	Figure.Types.Horse: 0,
}

signal card_selected(selected_card: FigureCard)

func _ready() -> void:
	set_figure_cards()

func set_figure_cards() -> void:
	for j in figures.keys().size():
		figure_cards[j].type = figures.keys()[j]
		figure_cards[j].qty = figures.values()[j]

func get_soldier_card() -> FigureCard:
	return figure_cards[0]

func get_soldier_energy() -> int:
	return get_soldier_card().figure_energies[Figure.Types.Soldier]

func _on_figure_card_selected(card: FigureCard):
	select_card(card)
	
	

func select_card(card: FigureCard):
	if selected_figure != null and selected_figure != card:
		selected_figure.selected_highlight.visible = false
	selected_figure = card
	emit_signal("card_selected", selected_figure)

func remove_figure():
	selected_figure.qty -= 1
	selected_figure.selected_highlight.visible = false
	selected_figure = null

func energy_changed(energy: float) -> void:
	for f in figure_cards:
		if energy >= f.energy:
			f.activate()
		else:
			f.deactivate()
