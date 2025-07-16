class_name Garrison extends Control

@onready var figure_cards: Array = $FigureCards.get_children()

var selected_figure: FigureCard

signal card_selected(selected_card: FigureCard)

func _on_figure_card_selected(card: FigureCard):
	select_card(card)

func select_card(card: FigureCard):
	selected_figure = card
	emit_signal("card_selected", selected_figure)

func activate(result: bool) -> void:
	visible = result
