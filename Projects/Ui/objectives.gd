class_name Objectives extends Control

const FAIL_OBJECTIVE_COLOR: Color = Color(0.85,0.28,0.28,1)
const SUCCESS_OBJECTIVE_COLOR: Color = Color(0.23,0.92,0.92,1)

var font: FontFile = load("res://Assets/Fonts/NotoSans-Bold.ttf")
@onready var objectives_container: VBoxContainer = $Objectives_panel/ObjectivesContainer
@onready var objectives_panel: Panel = $Objectives_panel

var objectives: Array[String] = [] :
	set(value):
		objectives = value
		for objective in objectives:
			var label = Label.new()
			label.size_flags_vertical = Control.SIZE_EXPAND_FILL
			label.add_theme_font_override("font", font)
			label.add_theme_font_size_override("font_size", 18)
			label.text = objective
			objectives_container.add_child(label)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if GameState.current_level_info["objectives"].size() > 0:
		objectives_panel.show()
		objectives = GameState.current_level_info["objectives"]


func complete_objectives(win: bool) -> void:
	if win:
		objectives_panel.modulate = SUCCESS_OBJECTIVE_COLOR
	else:
		objectives_panel.modulate = FAIL_OBJECTIVE_COLOR
