class_name FigureCard extends Control

@onready var sprites: Dictionary = {
	FigureComponent.Types.SOLDIER: load("res://Assets/Characters/Magma/Pawn/Pawn_front.png"),
	FigureComponent.Types.ELEPHANT: load("res://Assets/Characters/Magma/Elephant/Elephant_Front.png"),
	FigureComponent.Types.CHARIOT: load("res://Assets/Characters/Magma/Chariot/Chariot_Front.png"),
	FigureComponent.Types.HORSE: load("res://Assets/Characters/Magma/Horse/Horse_Front.png"),
	FigureComponent.Types.CANNON: load("res://Assets/Characters/Magma/Cannon/Cannon_Front.png")
}
const figure_names = {
	FigureComponent.Types.SOLDIER: "Xinvor",
	FigureComponent.Types.ELEPHANT: "Pigh",
	FigureComponent.Types.CHARIOT: "Navak",
	FigureComponent.Types.HORSE: "Aspet",
	FigureComponent.Types.CANNON: "Stver"
}

const figure_energies = {
	FigureComponent.Types.SOLDIER: 15,
	FigureComponent.Types.ELEPHANT: 20,
	FigureComponent.Types.CHARIOT: 60,
	FigureComponent.Types.HORSE: 20,
	FigureComponent.Types.CANNON: 30
}

@export var type: FigureComponent.Types 
@onready var click_sound: AudioStreamPlayer = $click_sound

signal selected(FigureCard)
signal deselected

var active: bool = true :
	set(a):
		active = a 
		if active:
			modulate = Color(1,1,1)
		else:
			modulate = Color(0.35, 0.35, 0.35)

var _selected :bool:
	set(s):
		_selected = s
		if _selected:
			scale *= 1.2
			emit_signal("selected", self)
		else:
			scale = Vector2(1,1)
			emit_signal("deselected")
			
var energy: float

func _ready() -> void:
	if type == FigureComponent.Types.CHARIOT:
		$card/image.scale = Vector2(2.5,2.5)
		$card/image.value = 60
		$card/image.position = Vector2(-47,20)
	elif type == FigureComponent.Types.ELEPHANT:
		$card/image.scale = Vector2(2.5,2.5)
		$card/image.value = 57
		$card/image.position = Vector2(5,44)
	elif type == FigureComponent.Types.CANNON:
		$card/image.scale = Vector2(5,5)
		$card/image.value = 34
		$card/image.position = Vector2(8,51)
	elif type == FigureComponent.Types.HORSE:
		$card/image.scale = Vector2(3.2,3.2)
		$card/image.value = 87
		$card/image.position = Vector2(2,51)
		
	$card/image.texture_progress = sprites[type]
	$card/info.text = figure_names[type] + " - " + str(figure_energies[type])
	energy = figure_energies[type]

func _on_card_gui_input(event: InputEvent):
	if event.is_action_pressed("click") and active:
		click_sound.play()
		_selected = !_selected

func deselect() -> void:
	_selected = false

func activate(result: bool):
	active = result
