class_name LevelMarker extends Node2D


enum LevelState {Closed, Open, Captured, Free}

const black: Color = Color(0,0,0)
const white: Color = Color(1,1,1)
const green: Color = Color(0,0.8,0)
const red: Color = Color(0.8,0,0)

const colors: Dictionary = {
	LevelState.Closed: black,
	LevelState.Open: white,
	LevelState.Captured: red,
	LevelState.Free: green
}

var state: LevelState : 
	set(s):
		state = s
		marker.modulate = colors[state]

var move_number: 
	set(n):
		move_number = n
		$move_number.text = str(move_number)

@onready var hover: Sprite2D = $Hover
@onready var marker: Sprite2D = $Marker
@export var level: PackedScene

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	state = LevelState.Open 


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_area_2d_mouse_entered() -> void:
	if state == LevelState.Closed:
		return
	hover.show()


func _on_area_2d_mouse_exited() -> void:
	hover.hide()


func _on_area_2d_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if state == LevelState.Closed:
		return
	if event is InputEventMouseButton:
		var mouse_event := event as InputEventMouseButton
		if mouse_event.button_index == MOUSE_BUTTON_LEFT and mouse_event.pressed:
			get_tree().change_scene_to_packed(level)
