class_name Garrison extends Control

@onready var figure_cards: Array = $FigureCards.get_children()

var selected_figure: FigureCard
var garrison_limitations: Array[FigureComponent.Types] = []

signal card_selected(selected_card: FigureCard)

func _on_figure_card_selected(card: FigureCard):
	select_card(card)

func select_card(card: FigureCard):
	if selected_figure != null:
		selected_figure.deselect()
	selected_figure = card
	emit_signal("card_selected", selected_figure)

func activate(result: bool) -> void:
	visible = result

func update_cards(energy: int) -> void:
	for card in figure_cards:
		card.activate(card.energy < energy and card.type not in garrison_limitations)
		card.deselect()

func deselect_cards() -> void:
	if selected_figure != null:
		selected_figure.deselect()
		selected_figure = null
