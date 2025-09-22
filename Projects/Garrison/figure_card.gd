class_name FigureCard extends Control

@onready var sprites: Dictionary = {
	FigureComponent.Types.SOLDIER: load("res://Assets/Characters/Magma/Pawn/Pawn_front.png"),
	FigureComponent.Types.ELEPHANT: load("res://Assets/Characters/Magma/Elephant/Elephant_Front.png"),
	FigureComponent.Types.CHARIOT: load("res://Assets/Characters/Magma/Chariot/Chariot_Front.png"),
	FigureComponent.Types.HORSE: load("res://Assets/Characters/Magma/Horse/Horse_Front.png"),
	FigureComponent.Types.CANNON: load("res://Assets/Characters/Magma/Cannon/Cannon_Front.png")
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
	FigureComponent.Types.ELEPHANT: 20,
	FigureComponent.Types.CHARIOT: 60,
	FigureComponent.Types.HORSE: 20,
	FigureComponent.Types.CANNON: 30
}

@export var type: FigureComponent.Types 

signal selected(FigureCard)
var active: bool = true :
	set(a):
		active = a 
		if active:
			modulate = Color(1,1,1)
		else:
			modulate = Color(0.35, 0.35, 0.35)

var _selected :bool
var energy: float

func _ready() -> void:
	if type == FigureComponent.Types.CHARIOT:
		$card/image.scale = Vector2(2.5,2.5)
		$card/image.value = 60
		$card/image.position = Vector2(-23,46)
	elif type == FigureComponent.Types.ELEPHANT:
		$card/image.scale = Vector2(3,3)
		$card/image.value = 50
		$card/image.position = Vector2(-5,59)
	elif type == FigureComponent.Types.CANNON:
		$card/image.scale = Vector2(5,5)
		$card/image.value = 40
		$card/image.position = Vector2(25,36)
	elif type == FigureComponent.Types.HORSE:
		$card/image.scale = Vector2(3.7,3.7)
		$card/image.value = 85
		$card/image.position = Vector2(0,54)
		
	$card/image.texture_progress = sprites[type]
	$card/info.text = figure_names[type] + " - " + str(figure_energies[type])
	energy = figure_energies[type]

func _on_card_gui_input(event: InputEvent):
	if event.is_action_pressed("click") and active:
		scale *= 1.2
		emit_signal("selected", self)

func deselect() -> void:
	scale = Vector2(1,1)

func activate(result: bool):
	active = result
