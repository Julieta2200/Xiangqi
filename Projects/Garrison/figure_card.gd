class_name FigureCard extends Control

@onready var sprites: Dictionary = {
	Figure.Types.Soldier: load("res://Assets/Characters/Pawn/Fire pawn.png"),
	Figure.Types.Elephant: load("res://Assets/tmp/elephant_red.png"),
	Figure.Types.Chariot: load("res://Assets/tmp/chariot_red.png"),
	Figure.Types.Horse: load("res://Assets/tmp/horse_red.png"),
	Figure.Types.Cannon: load("res://Assets/tmp/cannon_red.png")
}
var figure_names = {
	Figure.Types.Soldier: "Soldier",
	Figure.Types.Elephant: "Elephant",
	Figure.Types.Chariot: "Chariot",
	Figure.Types.Horse: "Horse",
	Figure.Types.Cannon: "Cannon"
}

signal selected(FigureCard)
@onready var highlight = $selected_highlight

var type: Figure.Types : 
	set(t):
		type = t
		if type != Figure.Types.Soldier:
			$card/image.scale = Vector2(0.3,0.3)
			$card/image.position = Vector2(55,5)
		else:
			$card/image.scale = Vector2(1,1)
		$card/image.texture = sprites[type]
		$card/name.text = figure_names[type]

var qty: int :
	set(q):
		qty = q
		$card/qty.text = "x"+str(qty)


func _process(delta):
	pass

func _on_card_gui_input(event: InputEvent):
	if event.is_pressed() and qty > 0:
		highlight.visible = true
		emit_signal("selected", self)
