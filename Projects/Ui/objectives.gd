class_name Objectives extends Control

const FAIL_OBJECTIVE_COLOR: Color = Color.RED
const SUCCESS_OBJECTIVE_COLOR: Color = Color.GREEN


@onready var objectives_container: VBoxContainer = $ObjectivesContainer
var objectives: Array[String] = [] :
	set(value):
		objectives = value
		for objective in objectives:
			var label = Label.new()
			label.add_theme_font_size_override("font_size", 30)
			label.text = objective
			objectives_container.add_child(label)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if GameState.current_level_info["objectives"].size() > 0:
		objectives = GameState.current_level_info["objectives"]


func complete_objectives(win: bool) -> void:
	for objective in objectives_container.get_children():
		if win:
			objective.add_theme_color_override("font_color", SUCCESS_OBJECTIVE_COLOR)
		else:
			objective.add_theme_color_override("font_color", FAIL_OBJECTIVE_COLOR)