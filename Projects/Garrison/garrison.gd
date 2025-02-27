extends Control

var selected_figure: FigureCard
@onready var figure_cards: Array = $Panel/FigureCards.get_children()

@export var figures: Dictionary = {
	Figure.Types.Soldier: 0,
	Figure.Types.Chariot: 0,
	Figure.Types.Cannon: 0,
	Figure.Types.Elephant: 0,
	Figure.Types.Horse: 0,
}

func _ready() -> void:
	for j in figures.keys().size():
		figure_cards[j].type = figures.keys()[j]
		figure_cards[j].qty = figures.values()[j]

func _on_figure_card_selected(card: FigureCard):
	if selected_figure != null and selected_figure != card:
		selected_figure.highlight.visible = false
	selected_figure = card
	

func removing_selected_figure():
	selected_figure.qty -= 1
	if selected_figure.qty == 0:
		selected_figure.highlight.visible = false
		selected_figure = null

func energy_changed(energy: float) -> void:
	for f in figure_cards:
		if energy >= f.energy:
			f.activate()
		else:
			f.deactivate()
