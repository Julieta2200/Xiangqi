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
			var label = Label.new()
			label.add_theme_font_size_override("font_size", 40)
			label.text = "• " + objective
			objectives_container.add_child(label)

@onready var title_label: Label  = $Panel/Title
@onready var story_label: RichTextLabel  = $Panel/Story
@onready var objectives_container: VBoxContainer  = $Panel/Objectives

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	setup("Title1", "This is a sample story for the level description. It can be quite long and detailed.", ["Find the hidden key", "Defeat all enemies", "Rescue the hostages"])


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func setup(title: String, story: String, additional_objectives: Array[String]) -> void:
	self.title = title
	self.story = story
	self.additional_objectives = additional_objectives
	show()

func _on_close_pressed() -> void:
	hide()
