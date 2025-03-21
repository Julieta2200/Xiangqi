extends Control

@onready var figure_cards: Array = $FigureCards.get_children()

var selected_figure: FigureCard
var check_selected_figure : bool 

signal card_selected(selected_card: FigureCard)

func get_soldier_card() -> FigureCard:
	return figure_cards[0]

func get_soldier_energy() -> int:
	return get_soldier_card().figure_energies[Figure.Types.Soldier]

func _on_figure_card_selected(card: FigureCard):
	select_card(card)
	

func select_card(card: FigureCard):
	if selected_figure != null and selected_figure != card:
		selected_figure.remove()
	selected_figure = card
	emit_signal("card_selected", selected_figure)

func remove_figure():
	selected_figure.remove()
	selected_figure = null

func energy_changed(energy: float) -> void:
	for f in figure_cards:
		if energy >= f.energy:
			f.activate()
		else:
			f.deactivate()
