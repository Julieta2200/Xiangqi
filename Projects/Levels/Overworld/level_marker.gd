class_name LevelMarker extends Node2D

enum LevelState {Closed, Open, Captured, Free}

@onready var hover_music: AudioStreamPlayer = $HoverMusic
@onready var hover_music_effects: AudioStreamPlayer = $HoverMusicEffects

@onready var images: Dictionary = {
	LevelState.Closed: load("res://Assets/Map/Markers/Big/Marker Blue.png"),
	LevelState.Open: load("res://Assets/Map/Markers/Big/Marker White.png"),
	LevelState.Captured: load("res://Assets/Map/Markers/Big/Marker Red.png"),
	LevelState.Free: load("res://Assets/Map/Markers/Big/Marker Green.png")
}

var state: LevelState : 
	set(s):
		state = s
		marker.texture = images[state]
		if state == LevelState.Open:
			pulse_effect()
		else:
			marker_animation.play("RESET")

var move_count: int

@onready var hover: TextureProgressBar = $Hover
@onready var marker: Sprite2D = $Marker
@onready var marker_animation: AnimationPlayer = $Marker/AnimationPlayer

@export var level_description: LevelDescription
@export var level: PackedScene
@export var title: String
@export var story: String
@export var additional_objectives: Array[String] = []
@export var number: String

var hover_music_off = preload("res://Assets/Music/SFX and music/UI SFX-Overworld-Hover OFF.wav")
var hover_music_on = preload("res://Assets/Music/SFX and music/UI SFX-Overworld-Hover ON.wav")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	state = LevelState.Open 


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass


func _on_area_2d_mouse_entered() -> void:
	if state == LevelState.Closed:
		return
	$AnimationPlayer.play("hover")
	play_sound(hover_music)
	play_sound(hover_music_effects,hover_music_on)


func _on_area_2d_mouse_exited() -> void:
	if state != LevelState.Closed:
		hover_music.stop()
		play_sound(hover_music_effects, hover_music_off)
	$AnimationPlayer.play("RESET")


func _on_area_2d_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if state == LevelState.Closed:
		return
	if event is InputEventMouseButton:
		var mouse_event := event as InputEventMouseButton
		if mouse_event.button_index == MOUSE_BUTTON_LEFT and mouse_event.pressed:
			AudioManager.play_sound("button_select")
			level_description.setup(title, story, additional_objectives, level, number, move_count)

func play_sound(player: AudioStreamPlayer, stream: AudioStream = null) -> void:
	if stream:
		player.stream = stream
	player.play()

func pulse_effect() -> void:
	marker_animation.play("pulse")
