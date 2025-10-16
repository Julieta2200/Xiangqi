class_name LevelMarker extends Node2D


enum LevelState {Closed, Open, Captured, Free}

@onready var image: Dictionary = {
	LevelState.Closed: load("res://Assets/Map/Markers/Big/Marker Blue.png"),
	LevelState.Open: load("res://Assets/Map/Markers/Big/Marker White.png"),
	LevelState.Captured: load("res://Assets/Map/Markers/Big/Marker Red.png"),
	LevelState.Free: load("res://Assets/Map/Markers/Big/Marker Green.png")
}

var state: LevelState : 
	set(s):
		state = s
		marker.texture = image[state]

var move_count: 
	set(n):
		move_count = n
		move_count_label.text = str(move_count)

@onready var move_count_label: Label = $move_count
@onready var hover: Sprite2D = $Hover
@onready var marker: Sprite2D = $Marker

@export var level_description: LevelDescription
@export var level: PackedScene
@export var title: String
@export var story: String
@export var additional_objectives: Array[String] = []
@export var number: String

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	state = LevelState.Open 


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass


func _on_area_2d_mouse_entered() -> void:
	if state == LevelState.Closed:
		return
	hover.show()


func _on_area_2d_mouse_exited() -> void:
	hover.hide()


func _on_area_2d_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if state == LevelState.Closed:
		return
	if event is InputEventMouseButton:
		var mouse_event := event as InputEventMouseButton
		if mouse_event.button_index == MOUSE_BUTTON_LEFT and mouse_event.pressed:
			level_description.setup(title, story, additional_objectives, level, number)
