extends Control

var selected_figure: FigureCard
@onready var figure_cards: Array = $Panel/FigureCards.get_children()

signal save

func _on_figure_card_selected(card: FigureCard):
	if selected_figure != null and selected_figure != card:
		selected_figure.highlight.visible = false
	selected_figure = card

func fill_the_cards(figures):
	for j in figures.keys().size():
		figure_cards[j].type = figures.keys()[j]
		figure_cards[j].qty = figures.values()[j]

func removing_selected_figure():
	selected_figure.qty -= 1
	if selected_figure.qty == 0:
		selected_figure.highlight.visible = false
		selected_figure = null


func _on_save() -> void:
	emit_signal("save")
