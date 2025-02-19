class_name FigureCard extends Control

@onready var sprites: Dictionary = {
	Figure.Types.Advisor: load("res://Assets/Characters/Advisor/Raven.png"),
	Figure.Types.Soldier: load("res://Assets/Characters/Pawn/Fire pawn.png"),
	Figure.Types.Elephant: load("res://Assets/tmp/elephant_red.png"),
	Figure.Types.Chariot: load("res://Assets/tmp/chariot_red.png"),
	Figure.Types.Horse: load("res://Assets/tmp/horse_red.png"),
	Figure.Types.Cannon: load("res://Assets/tmp/cannon_red.png")
}

signal selected(FigureCard)

var type: Figure.Types : 
	set(t):
		type = t
		$card/image.texture = sprites[type]

var qty: int : 
	set(q):
		qty = q
		$card/qty.text = "x"+str(qty)

var hovered: bool

# Called when the node enters the scene tree for the first time.
func _ready():
	qty = 3
	type = Figure.Types.Advisor


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_card_gui_input(event: InputEvent):
	if event.is_pressed():
		emit_signal("selected", self)
