class_name LevelDescription extends Control

var title: String : 
	set(value):
		title = value
		title_label.text = title

var story: String : 
	set(value):
		story = value
		story_label.text = story

var additional_objectives: Array[String] = [] :
	set(value):
		additional_objectives = value
		for objective in objectives_container.get_children():
			objective.queue_free()

		for objective in additional_objectives:
			var task = HBoxContainer.new()
			var icon = TextureRect.new()
			var label = Label.new()
			icon.texture = icon_image
			icon.stretch_mode = TextureRect.STRETCH_KEEP_CENTERED
			label.text = objective
			label.add_theme_font_size_override("font_size", 40)
			task.add_theme_constant_override("separation", 30)
			task.size_flags_vertical = Control.SIZE_EXPAND_FILL
			objectives_container.add_child(task)
			task.add_child(icon)
			task.add_child(label)

var number: String = ""

var level: PackedScene

@onready var title_label: Label  = $Panel/Title
@onready var story_label: RichTextLabel  = $Panel/Story
@onready var objectives_container: VBoxContainer  = $Panel/TaskPanel/Objectives

@onready var icon_image = load("res://Assets/UI/Level Description/icon.png")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	hide()


func setup(title: String, story: String, additional_objectives: Array[String], level: PackedScene, number: String) -> void:
	self.title = title
	self.story = story
	self.additional_objectives = additional_objectives
	self.level = level
	self.number = number
	show()

func _on_close_pressed() -> void:
	hide()
	
func _on_play_pressed() -> void:
	if level:
		GameState.current_level_info["scene"] = level
		GameState.current_level_info["name"] = number
		get_tree().change_scene_to_file("res://Projects/KarmaTable/karma_table.tscn")
