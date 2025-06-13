class_name FigureCard extends Control

@onready var sprites: Dictionary = {
	Figure.Types.Soldier: load("res://Assets/Characters/Magma/Pawn/Pawn_front.png"),
	Figure.Types.Elephant: load("res://Assets/Characters/Magma/Pawn/Pawn_front.png"),
	Figure.Types.Chariot: load("res://Assets/tmp/chariot_red.png"),
	Figure.Types.Horse: load("res://Assets/tmp/horse_red.png"),
	Figure.Types.Cannon: load("res://Assets/tmp/cannon_red.png")
}
const figure_names = {
	Figure.Types.Soldier: "Pawn",
	Figure.Types.Elephant: "Elephant",
	Figure.Types.Chariot: "Chariot",
	Figure.Types.Horse: "Horse",
	Figure.Types.Cannon: "Cannon"
}

const figure_energies = {
	Figure.Types.Soldier: 15,
	Figure.Types.Elephant: 30,
	Figure.Types.Chariot: 50,
	Figure.Types.Horse: 25,
	Figure.Types.Cannon: 40
}

@export var type: Figure.Types 

signal selected(FigureCard)
var active: bool
var _selected :bool
var energy: float

func _ready() -> void:
	if type != Figure.Types.Soldier:
		$card/image.scale = Vector2(0.3,0.3)
		$card/image.position = Vector2(55,5)
		
	$card/image.texture_progress = sprites[type]
	$card/name.text = figure_names[type]
	energy = figure_energies[type]

func _on_card_gui_input(event: InputEvent):
	if event.is_pressed() and active:
		emit_signal("selected", self)
		_selected = true
		select()

func remove():
	_selected = false
	scale = Vector2.ONE

func select():
	scale = Vector2(1.2,1.2)

func deactivate() -> void:
	active = false
	set_modulate(Color8(73,73,73))

func activate() -> void:
	active = true
	set_modulate(Color8(255,255,255))
	
func highlight() -> void:
	$AnimationPlayer.play("highlight")

func unhighlight() -> void:
	$AnimationPlayer.play("RESET")

func _on_card_mouse_entered() -> void:
	if !_selected and active:
		select()

func _on_card_mouse_exited() -> void:
	if !_selected and active:
		remove()
