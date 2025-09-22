class_name BoardMarker extends Node2D

enum Highlights {NONE, MOVE, CAPTURE, SPAWN, SELECTED, SPECIAL}

var board_position: Vector2i
var clickable: bool = true
@onready var walking_marker: Sprite2D = $walking_marker
@onready var spawn_marker: AnimatedSprite2D = $spawn_marker
@onready var spawn_light: AnimatedSprite2D = $spawn_marker/light
var board: BoardV2

signal figure_move(marker)
signal figure_spawn(marker)
signal spawn_done(marker)
signal highlight_end
signal special(marker)

var state: Highlights
var trap: bool = false

func _on_area_2d_input_event(viewport, event, shape_idx):
	if clickable and event is InputEventMouseButton:
		var mouse_event := event as InputEventMouseButton
		if mouse_event.button_index == MOUSE_BUTTON_LEFT and mouse_event.pressed:
			click()

func click() -> void:
	match state:
		Highlights.MOVE, Highlights.CAPTURE:
			emit_signal("figure_move",self)
		Highlights.SPAWN:
			spawn_light.show()
			spawn_light.play("light")
			emit_signal("figure_spawn",self)
		Highlights.SPECIAL:
			emit_signal("special", self)

func highlight(type: Highlights) -> void:
	state = type
	if board.state.has(board_position):
		var figure: FigureComponent = board.state[board_position]
		if figure.target_component != null:
			figure.target_component.active = true
			figure.target_component.marker = self
			clickable = false
			
	match type:
		Highlights.MOVE:
			$walking_marker/highlight.play("highlight")
			walking_marker.show()
		Highlights.CAPTURE:
			$walking_marker/highlight.play("capture_highlight")
			walking_marker.show()
		Highlights.SPAWN:
			spawn_marker.show()
		Highlights.SELECTED:
			$walking_marker/highlight.play("capture_highlight")
			walking_marker.show()
			$walking_marker/highlight.show()
		Highlights.SPECIAL:
			$special_marker.show()
		
		
func unhighlight():
	if state == Highlights.SELECTED:
		$walking_marker/highlight.hide()
	spawn_marker.hide()
	walking_marker.hide()
	$special_marker.hide()
	state = Highlights.NONE
	clickable = true
	if board.state.has(board_position):
		var figure: FigureComponent = board.state[board_position]
		if figure.target_component != null:
			figure.target_component.active = false
			figure.target_component.marker = null

func _on_area_2d_mouse_entered() -> void:
	$walking_marker/highlight.visible = $walking_marker.visible

func _on_area_2d_mouse_exited() -> void:
	if state == Highlights.SELECTED:
		return
	$walking_marker/highlight.hide()

func _on_spawn_light_animation_finished() -> void:
	emit_signal("spawn_done", self)
	await get_tree().process_frame
	spawn_light.hide()
