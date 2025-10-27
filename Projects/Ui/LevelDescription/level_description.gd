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

@onready var hover_music: AudioStreamPlayer = $HoverMusic
@onready var hover_music_effects: AudioStreamPlayer = $HoverMusicEffects

var sounds := {
	"hover_off": preload("res://Assets/Music/UI SFX-Overworld-Hover OFF.wav"),

	"play_hover_on": preload("res://Assets/Music/overworld/UI SFX-Overworld-PLAY BUTTON HOVER ON.wav"),
	"play_hover_loop": preload("res://Assets/Music/overworld/UI SFX-Overworld-CLOSE BUTTON HOVER LOOP.wav"),
	
	"close_hover_on": preload("res://Assets/Music/overworld/UI SFX-Overworld-CLOSE BUTTON HOVER ON.wav"),
	"close_hover_loop": preload("res://Assets/Music/overworld/UI SFX-Overworld-PLAY BUTTON HOVER LOOP.wav"),
}

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
	AudioManager.play_sound("button_select")
	hide()
	
func _on_play_pressed() -> void:
	if level:
		AudioManager.play_sound("play_button_select")
		GameState.current_level_info["scene"] = level
		GameState.current_level_info["name"] = number
		GameState.current_level_info["objectives"] = additional_objectives
		get_tree().change_scene_to_file("res://Projects/KarmaTable/karma_table.tscn")


func _on_close_mouse_entered() -> void:
	play_sound(hover_music, "close_hover_loop")
	play_sound(hover_music_effects, "close_hover_on")

func _on_play_mouse_entered() -> void:
	play_sound(hover_music, "play_hover_loop")
	play_sound(hover_music_effects, "play_hover_on")

func _on_button_mouse_exited() -> void:
	if !hover_music.playing:
		return
	hover_music.stop()
	play_sound(hover_music_effects, "hover_off")

func play_sound(player: AudioStreamPlayer, sound_name: String) -> void:
	player.stream = sounds[sound_name]
	player.play()
