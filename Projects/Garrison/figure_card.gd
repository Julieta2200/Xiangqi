class_name FigureCard extends Control

@onready var sprites: Dictionary = {
	FigureComponent.Types.SOLDIER: load("res://Assets/Characters/Magma/Pawn/Pawn_front.png"),
	FigureComponent.Types.ELEPHANT: load("res://Assets/tmp/elephant_red.png"),
	FigureComponent.Types.CHARIOT: load("res://Assets/tmp/chariot_red.png"),
	FigureComponent.Types.HORSE: load("res://Assets/tmp/horse_red.png"),
	FigureComponent.Types.CANNON: load("res://Assets/tmp/cannon_red.png")
}
const figure_names = {
	FigureComponent.Types.SOLDIER: "Pawn",
	FigureComponent.Types.ELEPHANT: "Elephant",
	FigureComponent.Types.CHARIOT: "Chariot",
	FigureComponent.Types.HORSE: "Horse",
	FigureComponent.Types.CANNON: "Cannon"
}

const figure_energies = {
	FigureComponent.Types.SOLDIER: 15,
	FigureComponent.Types.ELEPHANT: 30,
	FigureComponent.Types.CHARIOT: 50,
	FigureComponent.Types.HORSE: 25,
	FigureComponent.Types.CANNON: 40
}

@export var type: FigureComponent.Types 

signal selected(FigureCard)
var active: bool = true
var _selected :bool
var energy: float

func _ready() -> void:
	if type != FigureComponent.Types.SOLDIER:
		$card/image.scale = Vector2(1.3,1.3)
		$card/image.value = 100
		
	$card/image.texture_progress = sprites[type]
	$card/name.text = figure_names[type]
	energy = figure_energies[type]

func _on_card_gui_input(event: InputEvent):
	if event.is_pressed() and active:
		emit_signal("selected", self)

func activate(result: bool):
	active = result
