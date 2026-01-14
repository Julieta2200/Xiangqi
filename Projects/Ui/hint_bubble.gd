class_name HintBubble extends Control

@onready var hint_label: RichTextLabel = $Panel/Hint
@onready var number_label: Label = $Panel/Number
@onready var next_button: Button = $Panel/Button
@onready var hover_music: AudioStreamPlayer = $HoverMusic
@onready var hover_music_effects: AudioStreamPlayer = $HoverMusicEffects

@export var hint: String = ""
@export var number: String = ""

signal hint_finished()

var hover_music_on = preload("res://Assets/Music/SFX and music/UI SFX-Karma Table-BUTTON HOVER ON.wav")
var hover_music_off = preload("res://Assets/Music/SFX and music/UI SFX-Karma Table-BUTTON HOVER OFF.wav")
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	hint_label.text = tr(hint)
	number_label.text = number
	next_button.text = tr("NEXT")


func _on_button_pressed() -> void:
	hover_music.play()
	emit_signal("hint_finished")
	hide()


func _on_button_mouse_entered() -> void:
	hover_music_effects.stream = hover_music_on
	hover_music_effects.play()


func _on_button_mouse_exited() -> void:
	hover_music_effects.stream = hover_music_off
	hover_music_effects.play()
