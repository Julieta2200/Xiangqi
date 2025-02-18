extends Control

var selected_figure: FigureCard

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_figure_card_selected(card: FigureCard):
	selected_figure = card
