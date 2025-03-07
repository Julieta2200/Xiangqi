extends Control

@onready var figure_cards: Array = $Panel/FigureCards.get_children()

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
	for j in figures.keys().size():
		figure_cards[j].type = figures.keys()[j]
		figure_cards[j].qty = figures.values()[j]

func get_soldier_card() -> FigureCard:
	return figure_cards[0]


func _on_figure_card_selected(card: FigureCard):
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
